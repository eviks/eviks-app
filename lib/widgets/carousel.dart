import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

import '../constants.dart';

class Carousel extends StatefulWidget {
  const Carousel({
    Key? key,
    required this.images,
    required this.height,
    this.imageSize = '640',
    required this.external,
    required this.temp,
    this.displayIndicator = true,
  }) : super(key: key);

  final List<String> images;
  final double height;
  final String imageSize;
  final bool external;
  final bool temp;
  final bool displayIndicator;

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
    return Stack(
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
          itemCount: widget.images.length,
          itemBuilder: (ctx, index, _) {
            return CachedNetworkImage(
              imageUrl: widget.external
                  ? widget.images[index]
                  : '$baseUrl/uploads/${widget.temp ? 'temp/' : ''}post_images/${widget.images[index]}/image_${widget.imageSize}.webp',
              placeholder: (context, url) => const SkeletonAvatar(
                style: SkeletonAvatarStyle(width: double.infinity),
              ),
              width: double.infinity,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 100),
            );
          },
        ),
        if (widget.displayIndicator)
          SizedBox(
            height: widget.height,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      16.0,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    '${_currentIndex + 1}/${widget.images.length}',
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
