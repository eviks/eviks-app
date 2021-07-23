import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PostDetailMap extends StatelessWidget {
  final List<double> location;

  const PostDetailMap(this.location);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(location[1], location[0]),
      ),
      layers: [
        TileLayerOptions(
            urlTemplate:
                'http://maps.gomap.az/info/xyz.do?lng=az&x={x}&y={y}&z={z}&f=jpg'),
        MarkerLayerOptions(markers: [
          Marker(
              point: LatLng(location[1], location[0]),
              builder: (ctx) => const FlutterLogo())
        ]),
      ],
    );
  }
}
