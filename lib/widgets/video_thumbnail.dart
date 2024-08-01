import 'package:cached_network_image/cached_network_image.dart';
import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';

import './video_player.dart';

class VideoThumbnail extends StatelessWidget {
  final String videoId;

  const VideoThumbnail({required this.videoId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final thumbnail = 'https://img.youtube.com/vi/${videoId}/hqdefault.jpg';
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayer(
              videoId: videoId,
            ),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: thumbnail,
            width: double.infinity,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 100),
          ),
          IconButton(onPressed: () {}, icon: const Icon(CustomIcons.bell)),
        ],
      ),
    );
  }
}
