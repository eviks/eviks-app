import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../providers/posts.dart';
import '../../widgets/icon_choise_chip.dart';

class AdditionalFilters extends StatelessWidget {
  const AdditionalFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filters = Provider.of<Posts>(context).filters;
    void updateFilters(Map<String, dynamic> newValues) {
      Provider.of<Posts>(context, listen: false).updateFilters(newValues);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: Text(
            AppLocalizations.of(context)!.additionalFilters,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            IconChoiseChip(
              icon: CustomIcons.play,
              label: Text(
                AppLocalizations.of(context)!.hasVideo,
              ),
              value: filters.hasVideo ?? false,
              onSelected: (bool selected) {
                updateFilters({'hasVideo': selected});
              },
            ),
            IconChoiseChip(
              icon: CustomIcons.document,
              label: Text(
                AppLocalizations.of(context)!.documented,
              ),
              value: filters.documented ?? false,
              onSelected: (bool selected) {
                updateFilters({'documented': selected});
              },
            ),
            IconChoiseChip(
              icon: LucideIcons.user,
              label: Text(
                AppLocalizations.of(context)!.fromOwner,
              ),
              value: filters.fromOwner ?? false,
              onSelected: (bool selected) {
                updateFilters({'fromOwner': selected});
              },
            ),
            IconChoiseChip(
              icon: CustomIcons.hammer,
              label: Text(
                AppLocalizations.of(context)!.withoutRedevelopment,
              ),
              value: filters.withoutRedevelopment ?? false,
              onSelected: (bool selected) {
                updateFilters({'withoutRedevelopment': selected});
              },
            ),
          ],
        ),
      ],
    );
  }
}
