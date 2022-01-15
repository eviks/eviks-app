import 'package:eviks_mobile/icons.dart';
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
        _GeneralInfoItem(
          value: dealTypeDescriptionAlternative(post.dealType, context),
          label: AppLocalizations.of(context)!.dealTypeTitle,
        ),
        _GeneralInfoItem(
          value: estateTypeDescription(post.estateType, context),
          label: AppLocalizations.of(context)!.estateTypeTitle,
        ),
        if (post.estateType == EstateType.apartment &&
            post.apartmentType != null)
          _GeneralInfoItem(
            value: apartmentTypeDescription(post.apartmentType!, context),
            label: AppLocalizations.of(context)!.apartmentType,
          ),
        _GeneralInfoItem(
          value: post.rooms.toString(),
          label: AppLocalizations.of(context)!.rooms,
        ),
        _GeneralInfoItem(
          value: '${post.sqm} ${AppLocalizations.of(context)!.m2}',
          label: AppLocalizations.of(context)!.sqm,
        ),
        if (post.livingRoomsSqm != null && post.livingRoomsSqm != 0)
          _GeneralInfoItem(
            value: '${post.livingRoomsSqm} ${AppLocalizations.of(context)!.m2}',
            label: AppLocalizations.of(context)!.livingRoomsSqm,
          ),
        if (post.kitchenSqm != null && post.kitchenSqm != 0)
          _GeneralInfoItem(
            value: '${post.kitchenSqm} ${AppLocalizations.of(context)!.m2}',
            label: AppLocalizations.of(context)!.kitchenSqm,
          ),
        if (post.estateType == EstateType.house &&
            post.lotSqm != null &&
            post.lotSqm != 0)
          _GeneralInfoItem(
            value: post.lotSqm.toString(),
            label: AppLocalizations.of(context)!.lotSqm,
          ),
        if (post.estateType == EstateType.house &&
            post.totalFloors != null &&
            post.totalFloors != 0)
          _GeneralInfoItem(
            value: post.totalFloors.toString(),
            label: AppLocalizations.of(context)!.totalFloors,
          ),
        if (post.estateType == EstateType.apartment &&
            post.totalFloors != null &&
            post.floor != 0 &&
            post.floor != null &&
            post.totalFloors != 0)
          _GeneralInfoItem(
            value: '${post.floor} / ${post.totalFloors}',
            label: AppLocalizations.of(context)!.floor,
          ),
        _GeneralInfoIcon(
          icon: CustomIcons.document,
          label: AppLocalizations.of(context)!.documented,
          value: post.documented,
        ),
        _GeneralInfoIcon(
          icon: CustomIcons.paintroller,
          label: renovationDescription(
            post.renovation,
            context,
          ),
          value: true,
        ),
        _GeneralInfoIcon(
          icon: CustomIcons.hammer,
          label: AppLocalizations.of(context)!.redevelopment,
          value: post.redevelopment,
        ),
      ],
    );
  }
}

class _GeneralInfoItem extends StatelessWidget {
  final String value;
  final String label;
  const _GeneralInfoItem({
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

class _GeneralInfoIcon extends StatelessWidget {
  final bool? value;
  final IconData icon;
  final String label;
  const _GeneralInfoIcon({
    this.value,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return value ?? false
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 32.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(label),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
