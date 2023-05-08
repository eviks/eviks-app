import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../providers/posts.dart';
import '../../widgets/range_field.dart';

class FloorFilters extends StatelessWidget {
  const FloorFilters({Key? key}) : super(key: key);

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
            AppLocalizations.of(context)!.floor,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
        ),
        Visibility(
          visible: filters.estateType == EstateType.apartment,
          child: RangeField(
            title: AppLocalizations.of(context)!.floor,
            icon: CustomIcons.elevator,
            initialValueFrom:
                filters.floorMin != 0 ? filters.floorMin?.toString() : null,
            keyboardTypeFrom: TextInputType.number,
            inputFormattersFrom: [FilteringTextInputFormatter.digitsOnly],
            initialValueTo:
                filters.floorMax != 0 ? filters.floorMax?.toString() : null,
            keyboardTypeTo: TextInputType.number,
            inputFormattersTo: [FilteringTextInputFormatter.digitsOnly],
            onChangedFrom: (value) {
              updateFilters({
                'floorMin': value?.isEmpty ?? true ? null : int.parse(value!)
              });
            },
            onChangedTo: (value) {
              updateFilters({
                'floorMax': value?.isEmpty ?? true ? null : int.parse(value!)
              });
            },
          ),
        ),
        RangeField(
          title: AppLocalizations.of(context)!.totalFloors,
          icon: CustomIcons.elevator,
          initialValueFrom: filters.totalFloorsMin != 0
              ? filters.totalFloorsMin?.toString()
              : null,
          keyboardTypeFrom: TextInputType.number,
          inputFormattersFrom: [FilteringTextInputFormatter.digitsOnly],
          initialValueTo: filters.totalFloorsMax != 0
              ? filters.totalFloorsMax?.toString()
              : null,
          keyboardTypeTo: TextInputType.number,
          inputFormattersTo: [FilteringTextInputFormatter.digitsOnly],
          onChangedFrom: (value) {
            updateFilters({
              'totalFloorsMin':
                  value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
          onChangedTo: (value) {
            updateFilters({
              'totalFloorsMax':
                  value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
        ),
      ],
    );
  }
}
