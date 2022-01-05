import 'package:eviks_mobile/icons.dart';
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
          _BuildingInfo(
            value: post.yearBuild.toString(),
            label: AppLocalizations.of(context)!.yearBuild,
          ),
        if (post.ceilingHeight != null && post.ceilingHeight != 0)
          _BuildingInfo(
            value: post.ceilingHeight.toString(),
            label: AppLocalizations.of(context)!.ceilingHeight,
          ),
        const SizedBox(
          height: 8.0,
        ),
        _BuildingInfoIcon(
          icon: CustomIcons.elevator,
          label: AppLocalizations.of(context)!.elevator,
          value: post.elevator,
        ),
        _BuildingInfoIcon(
          icon: CustomIcons.parkinglot,
          label: AppLocalizations.of(context)!.parkingLot,
          value: post.parkingLot,
        ),
      ],
    );
  }
}

class _BuildingInfo extends StatelessWidget {
  final String value;
  final String label;
  const _BuildingInfo({
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

class _BuildingInfoIcon extends StatelessWidget {
  final bool? value;
  final IconData icon;
  final String label;
  const _BuildingInfoIcon({
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
