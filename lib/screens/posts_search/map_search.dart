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

class MapSearch extends StatefulWidget {
  const MapSearch({Key? key}) : super(key: key);

  @override
  State<MapSearch> createState() => _MapSearchState();
}

class _MapSearchState extends State<MapSearch> {
  List<LatLng> searchArea = [];
  bool drawing = false;

  void updateFilters() {
    Provider.of<Posts>(context, listen: false).updateFilters({
      'searchArea': searchArea.map((e) => [e.longitude, e.latitude]).toList()
    });

    Provider.of<Posts>(context, listen: false).fetchAndSetPostsLocations();
  }

  @override
  Widget build(BuildContext context) {
    final Filters filters = Provider.of<Posts>(context).filters;
    final List<PostLocation> postsLocations =
        Provider.of<Posts>(context).postsLocations;
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: LatLng(filters.city.y ?? 0, filters.city.x ?? 0),
            zoom: 12,
            maxZoom: 18,
            onPointerHover: (e, point) {
              if (drawing) {
                setState(() {
                  searchArea.add(point);
                });
              }
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
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderStrokeWidth: 5.0,
                  borderColor: Theme.of(context).primaryColor,
                  isFilled: true,
                )
              ],
            ),
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: 45,
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
