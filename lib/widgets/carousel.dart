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
  }) : super(key: key);

  final List<String> images;
  final double height;
  final String imageSize;

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _currentIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      for (final imageId in widget.images) {
        precacheImage(
          CachedNetworkImageProvider(
            '$baseUrl/uploads/post_images/$imageId/image_${widget.imageSize}.webp',
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
              imageUrl:
                  '$baseUrl/uploads/post_images/${widget.images[index]}/image_${widget.imageSize}.webp',
              placeholder: (context, url) => const SkeletonAvatar(
                style: SkeletonAvatarStyle(width: double.infinity),
              ),
              width: double.infinity,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 100),
            );
          },
        ),
        SizedBox(
          height: widget.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: widget.images.map((image) {
              final index = widget.images.indexOf(image);
              return Container(
                width: 10.0,
                height: 10.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 15.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).scaffoldBackgroundColor,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
