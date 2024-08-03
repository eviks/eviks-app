import 'package:cached_network_image/cached_network_image.dart';
import 'package:eviks_mobile/constants.dart';
import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoThumbnail extends StatelessWidget {
  final String videoLink;
  final bool buttonsVisibility;

  const VideoThumbnail({
    required this.videoLink,
    required this.buttonsVisibility,
    Key? key,
  }) : super(key: key);

  static String? convertUrlToId(String url) {
    if (!url.contains("http") && (url.length == 11)) return url;

    for (final exp in [
      RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$",
      ),
      RegExp(
        r"^https:\/\/(?:music\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$",
      ),
      RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11}).*$",
      ),
      RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$",
      ),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$"),
    ]) {
      final Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final thumbnail =
        'https://img.youtube.com/vi/${convertUrlToId(videoLink)}/hqdefault.jpg';
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(videoLink);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
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
          Container(
            color: Colors.black.withOpacity(0.8),
          ),
          Visibility(
            visible: buttonsVisibility,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CustomIcons.play,
                  color: lightColor,
                  size: 48.0,
                ),
                Text(
                  AppLocalizations.of(context)!.playVideo,
                  style: const TextStyle(color: lightColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
