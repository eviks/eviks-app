import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../constants.dart';
import '../widgets/counter.dart';
import '../widgets/sized_config.dart';

class FullImageViewer extends StatefulWidget {
  final List<String> images;
  final String imageSize;
  final bool isExternal;
  final bool temp;
  final int initialIndex;

  const FullImageViewer({
    Key? key,
    required this.images,
    required this.isExternal,
    required this.temp,
    this.imageSize = '640',
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<FullImageViewer> createState() => _FullImageViewerState();
}

class _FullImageViewerState extends State<FullImageViewer> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(
                  widget.isExternal
                      ? widget.images[index]
                      : '$baseUrl/uploads/${widget.temp ? 'temp/' : ''}post_images/${widget.images[index]}/image_${widget.imageSize}.webp',
                ),
                heroAttributes:
                    PhotoViewHeroAttributes(tag: widget.images[index]),
              );
            },
            pageController: PageController(initialPage: widget.initialIndex),
            onPageChanged: onPageChanged,
            itemCount: widget.images.length,
            loadingBuilder: (context, event) => Center(
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.expectedTotalBytes != null
                          ? event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!
                          : 0,
                ),
              ),
            ),
          ),
          Counter(
            height: SizeConfig.safeBlockVertical * 100,
            total: widget.images.length,
            current: currentIndex + 1,
          ),
        ],
      ),
    );
  }
}
