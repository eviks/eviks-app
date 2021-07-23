import 'package:flutter/material.dart';

import '../../widgets/carousel.dart';

class PostDetailHeader extends SliverPersistentHeaderDelegate {
  final List<String> images;
  final double height;

  PostDetailHeader({required this.images, required this.height});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Carousel(
      images: images,
      height: height,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
