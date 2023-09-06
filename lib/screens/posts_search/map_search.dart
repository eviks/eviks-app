import 'dart:async';
import 'dart:math';

import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import './post_item_modal.dart';
import '../../constants.dart';
import '../../models/filters.dart';
import '../../models/post_location.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';

class MapSearch extends StatefulWidget {
  const MapSearch({Key? key}) : super(key: key);

  @override
  State<MapSearch> createState() => _MapSearchState();
}

class _MapSearchState extends State<MapSearch> {
  late List<LatLng> searchArea = [];
  List<LatLng> currentPosition = [];
  bool drawing = false;
  MapPosition? _previousPosition;
  Timer? _moveEndTimer;
  bool _isLoading = false;
  final MapController _mapController = MapController();
  late Posts _appProvider;
  late LatLng _center;
  double _radius = 0.01;

  @override
  void initState() {
    final initialSearchArea =
        Provider.of<Posts>(context, listen: false).filters.searchArea;
    if (initialSearchArea != null) {
      setState(() {
        searchArea = initialSearchArea
            .map((element) => LatLng(element[1], element[0]))
            .toList();
      });
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _appProvider = Provider.of<Posts>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (searchArea.isEmpty) {
      currentPosition = [];
      _mapController.dispose();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _appProvider.updateFilters({
          'searchArea':
              currentPosition.map((e) => [e.longitude, e.latitude]).toList()
        }),
      );
    }
    super.dispose();
  }

  Future<void> updateFilters() async {
    var coordinates = [];
    if (searchArea.isNotEmpty) {
      coordinates = searchArea.map((e) => [e.longitude, e.latitude]).toList();
    } else {
      coordinates =
          currentPosition.map((e) => [e.longitude, e.latitude]).toList();
    }

    Provider.of<Posts>(context, listen: false)
        .updateFilters({'searchArea': coordinates});

    setState(() {
      _isLoading = true;
    });
    await Provider.of<Posts>(context, listen: false)
        .fetchAndSetPostsLocations();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Filters filters = Provider.of<Posts>(context).filters;
    final List<PostLocation> postsLocations =
        Provider.of<Posts>(context).postsLocations;

    void cancelMoveEndTimer() {
      if (_moveEndTimer != null && _moveEndTimer!.isActive) {
        _moveEndTimer!.cancel();
      }
    }

    void startMoveEndTimer(MapPosition position) {
      cancelMoveEndTimer();

      _moveEndTimer = Timer(const Duration(seconds: 1), () {
        setState(() {
          if (position.bounds != null && position.bounds!.isValid) {
            currentPosition = [
              position.bounds!.northWest,
              position.bounds!.northEast!,
              position.bounds!.southEast,
              position.bounds!.southWest!
            ];
          } else {
            currentPosition = [];
          }
          updateFilters();
        });
      });
    }

    void createCirclePolygon() {
      const sides = 36;
      const double rotation = 2 * pi / sides;

      final List<LatLng> polygonPoints = [];

      for (int i = 0; i < sides; i++) {
        final double angle = rotation * i;
        final double x = _center.latitude + _radius * cos(angle);
        final double y = _center.longitude + _radius * sin(angle);
        polygonPoints.add(LatLng(x, y));
      }

      setState(() {
        searchArea = polygonPoints;
      });
    }

    SizeConfig().init(context);

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(filters.city.y ?? 0, filters.city.x ?? 0),
            zoom: 12,
            maxZoom: 18,
            onPointerHover: (e, point) {
              if (drawing) {
                _center = point;
                _radius = 0.01 - (_mapController.zoom - 12) * 0.01 / 12;
                createCirclePolygon();
              }
            },
            onPositionChanged: (MapPosition position, bool gesture) {
              if (_previousPosition != null && position != _previousPosition) {
                cancelMoveEndTimer();
              }
              _previousPosition = position;
              startMoveEndTimer(position);
            },
            interactiveFlags: drawing
                ? InteractiveFlag.none
                : InteractiveFlag.pinchZoom |
                    InteractiveFlag.drag |
                    InteractiveFlag.doubleTapZoom,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://maps.gomap.az/info/xyz.do?lng=az&x={x}&y={y}&z={z}&f=jpg',
            ),
            PolygonLayer(
              polygons: [
                Polygon(
                  points: searchArea,
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderStrokeWidth: 5.0,
                  borderColor: Theme.of(context).primaryColor,
                  isFilled: true,
                )
              ],
            ),
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                anchor: AnchorPos.align(AnchorAlign.center),
                size: const Size(40.0, 40.0),
                fitBoundsOptions: const FitBoundsOptions(
                  padding: EdgeInsets.all(50),
                  maxZoom: 18,
                ),
                markers: postsLocations
                    .map(
                      (e) => Marker(
                        width: 65.0,
                        point: LatLng(e.location[1], e.location[0]),
                        builder: (ctx) => GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return PostItemModal(
                                  id: e.id,
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Theme.of(context).primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color: softDarkColor.withOpacity(0.4),
                                  blurRadius: 1,
                                  offset: const Offset(3, 1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                priceFormatter(context, e.price),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                builder: (context, markers) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: softDarkColor.withOpacity(0.4),
                          blurRadius: 1,
                          offset: const Offset(3, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        markers.length.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        if (_isLoading)
          const LinearProgressIndicator()
        else
          const SizedBox(
            height: 0,
          ),
        if (drawing)
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: SizeConfig.safeBlockHorizontal * 30.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Slider(
                    value: _radius,
                    onChanged: (value) {
                      _radius = value;
                      createCirclePolygon();
                    },
                    min: 0.001,
                    max: 0.05,
                  ),
                ],
              ),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Tooltip(
                  message: AppLocalizations.of(context)!.drawHint,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        drawing = !drawing;
                      });
                      if (drawing) {
                        setState(() {
                          searchArea = [];
                        });
                      }
                      updateFilters();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      fixedSize: const Size(50.0, 50.0),
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.9),
                      foregroundColor:
                          Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    child: drawing
                        ? const Icon(CustomIcons.checked)
                        : const Icon(CustomIcons.pencil),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                if (searchArea.isNotEmpty && !drawing)
                  Tooltip(
                    message: AppLocalizations.of(context)!.deleteAreaHint,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          searchArea = [];
                        });
                        updateFilters();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        fixedSize: const Size(50.0, 50.0),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.9),
                        foregroundColor:
                            Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      child: const Icon(CustomIcons.close),
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
