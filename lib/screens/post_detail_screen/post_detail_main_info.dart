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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _MainInfo(
            value: post.rooms.toString(),
            hint: AppLocalizations.of(context)!.roomsShort,
          ),
          _MainInfo(
            value: '${post.sqm.toString()} ${AppLocalizations.of(context)!.m2}',
            hint: AppLocalizations.of(context)!.sqmShort,
          ),
          if ((post.livingRoomsSqm ?? 0) > 0)
            _MainInfo(
              value:
                  '${post.livingRoomsSqm.toString()} ${AppLocalizations.of(context)!.m2}',
              hint: AppLocalizations.of(context)!.livingRoomsSqmShort,
            ),
          if ((post.kitchenSqm ?? 0) > 0)
            _MainInfo(
              value:
                  '${post.kitchenSqm.toString()} ${AppLocalizations.of(context)!.m2}',
              hint: AppLocalizations.of(context)!.kitchenSqmShort,
            ),
          if (post.estateType == EstateType.apartment)
            _MainInfo(
              value:
                  '${post.floor.toString()} / ${post.totalFloors.toString()}',
              hint: AppLocalizations.of(context)!.floor,
            ),
          if (post.estateType == EstateType.house)
            _MainInfo(
              value: '${post.lotSqm.toString()} ',
              hint: AppLocalizations.of(context)!.lotSqmShort,
            ),
          if (post.estateType == EstateType.house &&
              (post.totalFloors ?? 0) > 1)
            _MainInfo(
              value: '${post.lotSqm.toString()} ',
              hint: AppLocalizations.of(context)!.totalFloorsShort,
            ),
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
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Text(hint),
        ],
      ),
    );
  }
}
