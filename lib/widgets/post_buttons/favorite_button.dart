import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';

class FavoriteButton extends StatelessWidget {
  final int postId;
  final double? elevation;

  const FavoriteButton({
    required this.postId,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final _isFavorite =
        Provider.of<Auth>(context, listen: true).postIsFavorite(postId);
    final user = Provider.of<Auth>(context, listen: true).user;

    void _toggleFavoriteStatus() {
      if (user == null) {
        return;
      }

      if (_isFavorite) {
        Provider.of<Auth>(context, listen: false)
            .removePostFromFavorites(postId);
      } else {
        Provider.of<Auth>(context, listen: false).addPostToFavorites(postId);
      }
    }

    return ElevatedButton(
      onPressed: _toggleFavoriteStatus,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        fixedSize: const Size.fromRadius(25.0),
        elevation: elevation,
        primary: _isFavorite
            ? Theme.of(context).primaryColor
            : Theme.of(context).backgroundColor,
        onPrimary: _isFavorite
            ? Theme.of(context).backgroundColor
            : Theme.of(context).dividerColor,
      ),
      child: const Icon(CustomIcons.heart),
    );
  }
}
