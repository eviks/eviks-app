import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants.dart';

class ShareButton extends StatelessWidget {
  final int postId;
  final String districtName;
  final int price;
  final int rooms;
  final double? elevation;

  const ShareButton({
    required this.postId,
    required this.districtName,
    required this.price,
    required this.rooms,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final url = '$baseUrl/posts/$postId';
        final message = AppLocalizations.of(context)!
            .shareText(districtName, price, rooms, url);
        await Share.share(message);
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(45, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        fixedSize: const Size(45.0, 45.0),
        elevation: elevation,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).dividerColor,
      ),
      child: const Icon(
        CustomIcons.share,
        size: 18.0,
      ),
    );
  }
}
