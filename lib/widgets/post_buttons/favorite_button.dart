import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../screens/auth_screen/auth_screen.dart';

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
        Navigator.of(context).pushNamed(AuthScreen.routeName);
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
        padding: const EdgeInsets.all(4.0),
        minimumSize: const Size(50, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        fixedSize: const Size(50.0, 50.0),
        elevation: elevation,
        primary: _isFavorite
            ? Theme.of(context).primaryColor
            : Theme.of(context).backgroundColor,
        onPrimary: _isFavorite
            ? Theme.of(context).backgroundColor
            : Theme.of(context).dividerColor,
      ),
      child: const Icon(
        CustomIcons.heart,
      ),
    );
  }
}
