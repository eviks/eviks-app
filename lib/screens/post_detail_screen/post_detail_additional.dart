import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/post.dart';

class PostDetailAdditional extends StatelessWidget {
  const PostDetailAdditional({
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 16.0,
      children: [
        _AdditionalItem(
          value: post.kidsAllowed,
          icon: CustomIcons.kids,
          label: AppLocalizations.of(context)!.kidsAllowed,
        ),
        _AdditionalItem(
          value: post.petsAllowed,
          icon: CustomIcons.pets,
          label: AppLocalizations.of(context)!.petsAllowed,
        ),
        _AdditionalItem(
          value: post.garage,
          icon: CustomIcons.garage,
          label: AppLocalizations.of(context)!.garage,
        ),
        _AdditionalItem(
          value: post.pool,
          icon: CustomIcons.pool,
          label: AppLocalizations.of(context)!.pool,
        ),
        _AdditionalItem(
          value: post.bathhouse,
          icon: CustomIcons.bathhouse,
          label: AppLocalizations.of(context)!.bathhouse,
        ),
        _AdditionalItem(
          value: post.balcony,
          icon: CustomIcons.balcony,
          label: AppLocalizations.of(context)!.balcony,
        ),
        _AdditionalItem(
          value: post.furniture,
          icon: CustomIcons.furniture,
          label: AppLocalizations.of(context)!.furniture,
        ),
        _AdditionalItem(
          value: post.kitchenFurniture,
          icon: CustomIcons.kitchenfurniture,
          label: AppLocalizations.of(context)!.kitchenFurniture,
        ),
        _AdditionalItem(
          value: post.cableTv,
          icon: CustomIcons.cabletv,
          label: AppLocalizations.of(context)!.cableTv,
        ),
        _AdditionalItem(
          value: post.phone,
          icon: CustomIcons.phone,
          label: AppLocalizations.of(context)!.phone,
        ),
        _AdditionalItem(
          value: post.internet,
          icon: CustomIcons.internet,
          label: AppLocalizations.of(context)!.internet,
        ),
        _AdditionalItem(
          value: post.electricity,
          icon: CustomIcons.electricity,
          label: AppLocalizations.of(context)!.electricity,
        ),
        _AdditionalItem(
          value: post.gas,
          icon: CustomIcons.gas,
          label: AppLocalizations.of(context)!.gas,
        ),
        _AdditionalItem(
          value: post.water,
          icon: CustomIcons.water,
          label: AppLocalizations.of(context)!.water,
        ),
        _AdditionalItem(
          value: post.heating,
          icon: CustomIcons.heat,
          label: AppLocalizations.of(context)!.heating,
        ),
        _AdditionalItem(
          value: post.tv,
          icon: CustomIcons.tv,
          label: AppLocalizations.of(context)!.tv,
        ),
        _AdditionalItem(
          value: post.conditioner,
          icon: CustomIcons.conditioner,
          label: AppLocalizations.of(context)!.conditioner,
        ),
        _AdditionalItem(
          value: post.washingMachine,
          icon: CustomIcons.washingmachine,
          label: AppLocalizations.of(context)!.washingMachine,
        ),
        _AdditionalItem(
          value: post.dishwasher,
          icon: CustomIcons.dishwasher,
          label: AppLocalizations.of(context)!.dishwasher,
        ),
        _AdditionalItem(
          value: post.refrigerator,
          icon: CustomIcons.refrigerator,
          label: AppLocalizations.of(context)!.refrigerator,
        ),
      ],
    );
  }
}

class _AdditionalItem extends StatelessWidget {
  final bool? value;
  final IconData icon;
  final String label;
  const _AdditionalItem({
    this.value,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return value ?? false
        ? Row(
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
          )
        : const SizedBox.shrink();
  }
}
