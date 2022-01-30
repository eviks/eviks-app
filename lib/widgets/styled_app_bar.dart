import 'dart:ui';

import 'package:flutter/material.dart';

class StyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final Widget? title;
  final Widget? leading;

  @override 
   final Size preferredSize; 

  const StyledAppBar({this.actions, this.title, this.leading ,this.preferredSize = const Size.fromHeight(60.0), Key? key})  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Opacity(
          opacity: 0.8,
          child: AppBar(actions: actions, title: title, leading: leading),
        ),
      ),
    );
  }
}
