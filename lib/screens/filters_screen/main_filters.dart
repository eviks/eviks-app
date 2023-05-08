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
    final filters = Provider.of<Posts>(context).filters;

    void updateFilters(Map<String, dynamic> newValues) {
      Provider.of<Posts>(context, listen: false).updateFilters(newValues);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ToggleFormField<DealType>(
            values: DealType.values,
            initialValue: filters.dealType,
            getDescription: dealTypeFiltersDescription,
            onPressed: (DealType value) {
              updateFilters({'dealType': value});
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
            initialValue: filters.estateType,
            getDescription: estateTypeDescription,
            onPressed: (EstateType? value) {
              final Map<String, dynamic> newValues = {};

              newValues['estateType'] = value;
              if (value != EstateType.apartment) {
                newValues['apartmentType'] = null;
              } else {
                newValues['lotSqmMin'] = null;
                newValues['lotSqmMax'] = null;
              }

              updateFilters(newValues);
            },
            icons: const [
              CustomIcons.apartment,
              CustomIcons.house,
            ],
            allowUnselect: false,
          ),
        ),
        AnimatedOpacity(
          opacity: filters.estateType == EstateType.apartment ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Visibility(
            visible: filters.estateType == EstateType.apartment,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ToggleFormField<ApartmentType>(
                values: ApartmentType.values,
                initialValue: filters.apartmentType,
                getDescription: apartmentTypeDescription,
                onPressed: (ApartmentType? value) {
                  updateFilters({'apartmentType': value});
                },
                icons: const [
                  CustomIcons.newbuilding,
                  CustomIcons.secondarybuilding,
                ],
              ),
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
              filters.priceMin != 0 ? filters.priceMin?.toString() : null,
          keyboardTypeFrom: TextInputType.number,
          inputFormattersFrom: [FilteringTextInputFormatter.digitsOnly],
          initialValueTo:
              filters.priceMax != 0 ? filters.priceMax?.toString() : null,
          keyboardTypeTo: TextInputType.number,
          inputFormattersTo: [FilteringTextInputFormatter.digitsOnly],
          onChangedFrom: (value) {
            updateFilters({
              'priceMin': value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
          onChangedTo: (value) {
            updateFilters({
              'priceMax': value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
        ),
        RangeField(
          title: AppLocalizations.of(context)!.rooms,
          icon: CustomIcons.door,
          initialValueFrom:
              filters.roomsMin != 0 ? filters.roomsMin?.toString() : null,
          keyboardTypeFrom: TextInputType.number,
          inputFormattersFrom: [FilteringTextInputFormatter.digitsOnly],
          initialValueTo:
              filters.roomsMax != 0 ? filters.roomsMax?.toString() : null,
          keyboardTypeTo: TextInputType.number,
          inputFormattersTo: [FilteringTextInputFormatter.digitsOnly],
          onChangedFrom: (value) {
            updateFilters({
              'roomsMin': value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
          onChangedTo: (value) {
            updateFilters({
              'roomsMax': value?.isEmpty ?? true ? null : int.parse(value!)
            });
          },
        ),
      ],
    );
  }
}
