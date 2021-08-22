import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatefulWidget {
  const Carousel({
    Key? key,
    required this.images,
    required this.height,
  }) : super(key: key);

  final List<String> images;
  final double height;

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _currentIndex = 0;

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
                'http://192.168.1.9:5000/uploads/post_images/${widget.images[index]}/image_320.png',
                width: double.infinity,
                fit: BoxFit.cover,
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
