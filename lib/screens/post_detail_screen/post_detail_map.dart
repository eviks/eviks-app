import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

import '../../models/post.dart';

class PostDetailMap extends StatelessWidget {
  final Post post;

  const PostDetailMap(this.post);

  String _getlocationName(BuildContext context) {
    return '${post.city.getLocaliedName(context)}, ${post.district.getLocaliedName(context)}${post.subdistrict != null ? ', ${post.subdistrict!.getLocaliedName(context)}' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getlocationName(context),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              Text(post.address),
            ],
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(post.location[1], post.location[0]),
                zoom: 14,
                interactiveFlags: InteractiveFlag.pinchZoom |
                    InteractiveFlag.drag |
                    InteractiveFlag.doubleTapZoom,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        'http://maps.gomap.az/info/xyz.do?lng=az&x={x}&y={y}&z={z}&f=jpg'),
                MarkerLayerOptions(markers: [
                  Marker(
                    point: LatLng(post.location[1], post.location[0]),
                    builder: (ctx) => SvgPicture.asset(
                      "assets/img/svg/location.svg",
                    ),
                  )
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
