import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../providers/posts.dart';
import '../../widgets/range_field.dart';
import '../../widgets/toggle_field.dart';

class MainFilters extends StatelessWidget {
  const MainFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _filters = Provider.of<Posts>(context).filters;

    void _updateFilters(Map<String, dynamic> newValues) {
      Provider.of<Posts>(context, listen: false).updateFilters(newValues);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ToggleFormField<DealType>(
            values: DealType.values,
            initialValue: _filters.dealType,
            getDescription: dealTypeDescription,
            onPressed: (DealType value) {
              _updateFilters({'dealType': value});
            },
            icons: const [
              CustomIcons.sale,
              CustomIcons.rent,
              CustomIcons.rentperday,
            ],
            allowUnselect: false,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ToggleFormField<EstateType>(
            values: EstateType.values,
            initialValue: _filters.estateType,
            getDescription: estateTypeDescription,
            onPressed: (EstateType? value) {
              final Map<String, dynamic> _newValues = {};

              _newValues['estateType'] = value;
              if (value != EstateType.apartment) {
                _newValues['apartmentType'] = null;
              } else {
                _newValues['lotSqmMin'] = null;
                _newValues['lotSqmMax'] = null;
              }

              _updateFilters(_newValues);
            },
            icons: const [
              CustomIcons.apartment,
              CustomIcons.house,
            ],
          ),
        ),
        Visibility(
          visible: _filters.estateType == EstateType.apartment,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ToggleFormField<ApartmentType>(
              values: ApartmentType.values,
              initialValue: _filters.apartmentType,
              getDescription: apartmentTypeDescription,
              onPressed: (ApartmentType? value) {
                _updateFilters({'apartmentType': value});
              },
              icons: const [
                CustomIcons.newbuilding,
                CustomIcons.secondarybuilding,
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        RangeField(
          title: AppLocalizations.of(context)!.price,
          icon: CustomIcons.money,
          initialValueFrom:
              _filters.priceMin != 0 ? _filters.priceMin?.toString() : null,
          keyboardTypeFrom: TextInputType.number,
          inputFormattersFrom: [FilteringTextInputFormatter.digitsOnly],
          initialValueTo:
              _filters.priceMax != 0 ? _filters.priceMax?.toString() : null,
          keyboardTypeTo: TextInputType.number,
          inputFormattersTo: [FilteringTextInputFormatter.digitsOnly],
          onChangedFrom: (value) {
            _updateFilters({
              'priceMin': value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
          onChangedTo: (value) {
            _updateFilters({
              'priceMax': value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
        ),
        RangeField(
          title: AppLocalizations.of(context)!.rooms,
          icon: CustomIcons.door,
          initialValueFrom:
              _filters.roomsMin != 0 ? _filters.roomsMin?.toString() : null,
          keyboardTypeFrom: TextInputType.number,
          inputFormattersFrom: [FilteringTextInputFormatter.digitsOnly],
          initialValueTo:
              _filters.roomsMax != 0 ? _filters.roomsMax?.toString() : null,
          keyboardTypeTo: TextInputType.number,
          inputFormattersTo: [FilteringTextInputFormatter.digitsOnly],
          onChangedFrom: (value) {
            _updateFilters({
              'roomsMin': value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
          onChangedTo: (value) {
            _updateFilters({
              'roomsMax': value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
        ),
      ],
    );
  }
}
