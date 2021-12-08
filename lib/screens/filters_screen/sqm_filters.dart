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
    final _filters = Provider.of<Posts>(context).filters;
    void _updateFilters(Map<String, dynamic> newValues) {
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
          icon: CustomIcons.door,
          initialValueFrom:
              _filters.sqmMin != 0 ? _filters.sqmMin?.toString() : null,
          keyboardTypeFrom: TextInputType.number,
          inputFormattersFrom: [FilteringTextInputFormatter.digitsOnly],
          initialValueTo:
              _filters.sqmMax != 0 ? _filters.sqmMax?.toString() : null,
          keyboardTypeTo: TextInputType.number,
          inputFormattersTo: [FilteringTextInputFormatter.digitsOnly],
          onChangedFrom: (value) {
            _updateFilters(
                {'sqmMin': value?.isEmpty ?? true ? null : int.parse(value!)});
          },
          onChangedTo: (value) {
            _updateFilters(
                {'sqmMax': value?.isEmpty ?? true ? null : int.parse(value!)});
          },
        ),
        RangeField(
          title: AppLocalizations.of(context)!.livingRoomsSqm,
          icon: CustomIcons.door,
          initialValueFrom: _filters.livingRoomsSqmMin != 0
              ? _filters.livingRoomsSqmMin?.toString()
              : null,
          keyboardTypeFrom: TextInputType.number,
          inputFormattersFrom: [FilteringTextInputFormatter.digitsOnly],
          initialValueTo: _filters.livingRoomsSqmMax != 0
              ? _filters.livingRoomsSqmMax?.toString()
              : null,
          keyboardTypeTo: TextInputType.number,
          inputFormattersTo: [FilteringTextInputFormatter.digitsOnly],
          onChangedFrom: (value) {
            _updateFilters({
              'livingRoomsMin':
                  value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
          onChangedTo: (value) {
            _updateFilters({
              'livingRoomsMax':
                  value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
        ),
        RangeField(
          title: AppLocalizations.of(context)!.kitchenSqm,
          icon: CustomIcons.door,
          initialValueFrom: _filters.kitchenSqmMin != 0
              ? _filters.kitchenSqmMin?.toString()
              : null,
          keyboardTypeFrom: TextInputType.number,
          inputFormattersFrom: [FilteringTextInputFormatter.digitsOnly],
          initialValueTo: _filters.kitchenSqmMax != 0
              ? _filters.kitchenSqmMax?.toString()
              : null,
          keyboardTypeTo: TextInputType.number,
          inputFormattersTo: [FilteringTextInputFormatter.digitsOnly],
          onChangedFrom: (value) {
            _updateFilters({
              'kitchenSqmMin': value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
          onChangedTo: (value) {
            _updateFilters({
              'kitchenSqmMax': value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
        ),
        Visibility(
          visible: _filters.estateType == EstateType.house,
          child: RangeField(
            title: AppLocalizations.of(context)!.lotSqm,
            icon: CustomIcons.door,
            initialValueFrom:
                _filters.lotSqmMin != 0 ? _filters.lotSqmMin?.toString() : null,
            keyboardTypeFrom: TextInputType.number,
            inputFormattersFrom: [FilteringTextInputFormatter.digitsOnly],
            initialValueTo:
                _filters.lotSqmMax != 0 ? _filters.lotSqmMax?.toString() : null,
            keyboardTypeTo: TextInputType.number,
            inputFormattersTo: [FilteringTextInputFormatter.digitsOnly],
            onChangedFrom: (value) {
              _updateFilters({
                'lotSqmMin': value?.isEmpty ?? true ? null : int.parse(value!)
              });
            },
            onChangedTo: (value) {
              _updateFilters({
                'lotSqmMax': value?.isEmpty ?? true ? null : int.parse(value!)
              });
            },
          ),
        ),
      ],
    );
  }
}
