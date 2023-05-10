import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    final Filters filters = Provider.of<Posts>(context).filters;
    final List<PostLocation> postsLocations =
        Provider.of<Posts>(context).postsLocations;
    return FlutterMap(
      options: MapOptions(
        center: LatLng(filters.city.y ?? 0, filters.city.x ?? 0),
        zoom: 12,
        maxZoom: 18,
        interactiveFlags: InteractiveFlag.pinchZoom |
            InteractiveFlag.drag |
            InteractiveFlag.doubleTapZoom,
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://maps.gomap.az/info/xyz.do?lng=az&x={x}&y={y}&z={z}&f=jpg',
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
                    width: 60.0,
                    point: LatLng(e.location[1], e.location[0]),
                    builder: (ctx) => Container(
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
                          e.price.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
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
    );
  }
}
