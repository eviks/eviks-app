import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/counter.dart';
import '../widgets/full_image_viewer.dart';
import '../widgets/video_thumbnail.dart';

class Carousel extends StatefulWidget {
  const Carousel({
    Key? key,
    required this.images,
    required this.height,
    this.imageSize = '640',
    required this.external,
    required this.temp,
    this.displayIndicator = true,
    this.fullScreenView = false,
    this.videoLink,
    this.buttonsVisibility = false,
  }) : super(key: key);

  final List<String> images;
  final double height;
  final String imageSize;
  final bool external;
  final bool temp;
  final bool displayIndicator;
  final bool fullScreenView;
  final String? videoLink;
  final bool buttonsVisibility;

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _currentIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final imageId in widget.images) {
        precacheImage(
          CachedNetworkImageProvider(
            widget.external
                ? imageId
                : '$baseUrl/uploads/${widget.temp ? 'temp/' : ''}post_images/$imageId/image_${widget.imageSize}.webp',
          ),
          context,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final videoIncluded =
        widget.videoLink != null && widget.videoLink!.isNotEmpty;
    final totalCount = widget.images.length + (videoIncluded ? 1 : 0);

    return InkWell(
      onTap: widget.fullScreenView
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullImageViewer(
                    images: widget.images,
                    imageSize: '1280',
                    isExternal: widget.external,
                    temp: widget.temp,
                    initialIndex:
                        videoIncluded ? _currentIndex - 1 : _currentIndex,
                  ),
                ),
              );
            }
          : null,
      child: Stack(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
              height: widget.height,
              viewportFraction: 1,
              onPageChanged: (index, _) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            itemCount: totalCount,
            itemBuilder: (ctx, index, _) {
              if (videoIncluded && index == 0) {
                return VideoThumbnail(
                  videoLink: widget.videoLink!,
                  buttonsVisibility: widget.buttonsVisibility,
                );
              }
              final imageIndex = videoIncluded ? index - 1 : index;
              return CachedNetworkImage(
                imageUrl: widget.external
                    ? widget.images[imageIndex]
                    : '$baseUrl/uploads/${widget.temp ? 'temp/' : ''}post_images/${widget.images[imageIndex]}/image_${widget.imageSize}.webp',
                width: double.infinity,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 100),
              );
            },
          ),
          if (widget.displayIndicator)
            Counter(
              height: widget.height,
              total: totalCount,
              current: _currentIndex + 1,
            ),
        ],
      ),
    );
  }
}
