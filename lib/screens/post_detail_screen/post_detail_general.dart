import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/post.dart';

class PostDetailGeneral extends StatelessWidget {
  const PostDetailGeneral({
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GeneralItem(
          value: dealTypeDescriptionAlternative(post.dealType, context),
          label: AppLocalizations.of(context)!.dealTypeTitle,
        ),
        _GeneralItem(
          value: estateTypeDescription(post.estateType, context),
          label: AppLocalizations.of(context)!.estateTypeTitle,
        ),
        if (post.estateType == EstateType.apartment &&
            post.apartmentType != null)
          _GeneralItem(
            value: apartmentTypeDescription(post.apartmentType!, context),
            label: AppLocalizations.of(context)!.apartmentType,
          ),
        _GeneralItem(
          value: post.rooms.toString(),
          label: AppLocalizations.of(context)!.rooms,
        ),
        _GeneralItem(
          value: '${post.sqm} ${AppLocalizations.of(context)!.m2}',
          label: AppLocalizations.of(context)!.sqm,
        ),
        if (post.livingRoomsSqm != null && post.livingRoomsSqm != 0)
          _GeneralItem(
            value: '${post.livingRoomsSqm} ${AppLocalizations.of(context)!.m2}',
            label: AppLocalizations.of(context)!.livingRoomsSqm,
          ),
        if (post.kitchenSqm != null && post.kitchenSqm != 0)
          _GeneralItem(
            value: '${post.kitchenSqm} ${AppLocalizations.of(context)!.m2}',
            label: AppLocalizations.of(context)!.kitchenSqm,
          ),
        if (post.estateType == EstateType.house &&
            post.lotSqm != null &&
            post.lotSqm != 0)
          _GeneralItem(
            value: post.lotSqm.toString(),
            label: AppLocalizations.of(context)!.lotSqm,
          ),
        if (post.estateType == EstateType.house &&
            post.totalFloors != null &&
            post.totalFloors != 0)
          _GeneralItem(
            value: post.totalFloors.toString(),
            label: AppLocalizations.of(context)!.totalFloors,
          ),
        if (post.estateType == EstateType.apartment &&
            post.totalFloors != null &&
            post.floor != 0 &&
            post.floor != null &&
            post.totalFloors != 0)
          _GeneralItem(
            value: '${post.floor} / ${post.totalFloors}',
            label: AppLocalizations.of(context)!.floor,
          ),
      ],
    );
  }
}

class _GeneralItem extends StatelessWidget {
  final String value;
  final String label;
  const _GeneralItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 16.0, color: Theme.of(context).dividerColor),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
