import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/post.dart';

class PostDetailMainInfo extends StatelessWidget {
  const PostDetailMainInfo({
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          _MainInfo(
              value: post.rooms.toString(),
              hint: AppLocalizations.of(context)!.postRooms),
          _MainInfo(
              value: '${post.sqm.toString()} m²',
              hint: AppLocalizations.of(context)!.postSqm),
        ],
      ),
    );
  }
}

class _MainInfo extends StatelessWidget {
  const _MainInfo({
    Key? key,
    required this.value,
    required this.hint,
  }) : super(key: key);

  final String value;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          Text(hint),
        ],
      ),
    );
  }
}
