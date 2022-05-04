import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

import '../constants.dart';

class Carousel extends StatefulWidget {
  const Carousel(
      {Key? key,
      required this.images,
      required this.height,
      this.imageSize = '320'})
      : super(key: key);

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
      for (var i = 0; i < min(widget.images.length, 3); i++) {
        precacheImage(
            NetworkImage(
                '$baseUrl/uploads/post_images/${widget.images[i]}/image_${widget.imageSize}.png'),
            context);
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
                }),
            itemCount: widget.images.length,
            itemBuilder: (ctx, index, _) {
              return Image.network(
                '$baseUrl/uploads/post_images/${widget.images[index]}/image_${widget.imageSize}.png',
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext ctx, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const SkeletonAvatar(
                      style: SkeletonAvatarStyle(width: double.infinity),
                    );
                  }
                },
              );
            }),
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
