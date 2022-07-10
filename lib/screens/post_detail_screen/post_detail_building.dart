import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/post.dart';

class PostDetailBuilding extends StatelessWidget {
  const PostDetailBuilding({
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (post.yearBuild != null && post.yearBuild != 0)
          _BuildingInfoItem(
            value: post.yearBuild.toString(),
            label: AppLocalizations.of(context)!.yearBuild,
          ),
        if (post.ceilingHeight != null && post.ceilingHeight != 0)
          _BuildingInfoItem(
            value: post.ceilingHeight.toString(),
            label: AppLocalizations.of(context)!.ceilingHeight,
          ),
        if (post.elevator ?? false)
          _BuildingInfoItem(
            value: AppLocalizations.of(context)!.trueValue,
            label: AppLocalizations.of(context)!.elevator,
          ),
        if (post.parkingLot ?? false)
          _BuildingInfoItem(
            value: AppLocalizations.of(context)!.trueValue,
            label: AppLocalizations.of(context)!.parkingLot,
          ),
      ],
    );
  }
}

class _BuildingInfoItem extends StatelessWidget {
  final String value;
  final String label;
  const _BuildingInfoItem({
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
              fontSize: 16.0,
              color: Theme.of(context).dividerColor,
            ),
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
