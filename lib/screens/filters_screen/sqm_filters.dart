import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../providers/posts.dart';
import '../../widgets/range_field.dart';

class SqmFilters extends StatelessWidget {
  const SqmFilters({Key? key}) : super(key: key);

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
            AppLocalizations.of(context)!.sqmTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
        ),
        RangeField(
          title: AppLocalizations.of(context)!.sqm,
          icon: CustomIcons.sqm,
          initialValueFrom:
              filters.sqmMin != 0 ? filters.sqmMin?.toString() : null,
          keyboardTypeFrom: TextInputType.number,
          inputFormattersFrom: [FilteringTextInputFormatter.digitsOnly],
          initialValueTo:
              filters.sqmMax != 0 ? filters.sqmMax?.toString() : null,
          keyboardTypeTo: TextInputType.number,
          inputFormattersTo: [FilteringTextInputFormatter.digitsOnly],
          onChangedFrom: (value) {
            updateFilters(
              {'sqmMin': value?.isEmpty ?? true ? null : int.parse(value!)},
            );
          },
          onChangedTo: (value) {
            updateFilters(
              {'sqmMax': value?.isEmpty ?? true ? null : int.parse(value!)},
            );
          },
        ),
        RangeField(
          title: AppLocalizations.of(context)!.livingRoomsSqm,
          icon: CustomIcons.sqm,
          initialValueFrom: filters.livingRoomsSqmMin != 0
              ? filters.livingRoomsSqmMin?.toString()
              : null,
          keyboardTypeFrom: TextInputType.number,
          inputFormattersFrom: [FilteringTextInputFormatter.digitsOnly],
          initialValueTo: filters.livingRoomsSqmMax != 0
              ? filters.livingRoomsSqmMax?.toString()
              : null,
          keyboardTypeTo: TextInputType.number,
          inputFormattersTo: [FilteringTextInputFormatter.digitsOnly],
          onChangedFrom: (value) {
            updateFilters({
              'livingRoomsSqmMin':
                  value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
          onChangedTo: (value) {
            updateFilters({
              'livingRoomsSqmMax':
                  value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
        ),
        RangeField(
          title: AppLocalizations.of(context)!.kitchenSqm,
          icon: CustomIcons.sqm,
          initialValueFrom: filters.kitchenSqmMin != 0
              ? filters.kitchenSqmMin?.toString()
              : null,
          keyboardTypeFrom: TextInputType.number,
          inputFormattersFrom: [FilteringTextInputFormatter.digitsOnly],
          initialValueTo: filters.kitchenSqmMax != 0
              ? filters.kitchenSqmMax?.toString()
              : null,
          keyboardTypeTo: TextInputType.number,
          inputFormattersTo: [FilteringTextInputFormatter.digitsOnly],
          onChangedFrom: (value) {
            updateFilters({
              'kitchenSqmMin': value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
          onChangedTo: (value) {
            updateFilters({
              'kitchenSqmMax': value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
        ),
        Visibility(
          visible: filters.estateType == EstateType.house,
          child: RangeField(
            title: AppLocalizations.of(context)!.lotSqm,
            icon: CustomIcons.sqm,
            initialValueFrom:
                filters.lotSqmMin != 0 ? filters.lotSqmMin?.toString() : null,
            keyboardTypeFrom: TextInputType.number,
            inputFormattersFrom: [FilteringTextInputFormatter.digitsOnly],
            initialValueTo:
                filters.lotSqmMax != 0 ? filters.lotSqmMax?.toString() : null,
            keyboardTypeTo: TextInputType.number,
            inputFormattersTo: [FilteringTextInputFormatter.digitsOnly],
            onChangedFrom: (value) {
              updateFilters({
                'lotSqmMin': value?.isEmpty ?? true ? null : int.parse(value!)
              });
            },
            onChangedTo: (value) {
              updateFilters({
                'lotSqmMax': value?.isEmpty ?? true ? null : int.parse(value!)
              });
            },
          ),
        ),
      ],
    );
  }
}
