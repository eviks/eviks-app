import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/filters.dart';
import '../../models/post.dart';
import '../../widgets/range_field.dart';
import '../../widgets/toggle_field.dart';

class MainFilters extends StatefulWidget {
  final Filters filters;

  const MainFilters({required this.filters, Key? key}) : super(key: key);

  @override
  _MainFiltersState createState() => _MainFiltersState();
}

class _MainFiltersState extends State<MainFilters> {
  late bool _isApartment;

  @override
  void initState() {
    _isApartment = widget.filters.estateType == EstateType.apartment;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ToggleFormField<DealType>(
            values: DealType.values,
            initialValue: widget.filters.dealType,
            getDescription: dealTypeDescription,
            onPressed: (DealType? value) {
              widget.filters.dealType = value;
            },
            icons: const [
              CustomIcons.sale,
              CustomIcons.rent,
              CustomIcons.rentperday,
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ToggleFormField<EstateType>(
            values: EstateType.values,
            initialValue: widget.filters.estateType,
            getDescription: estateTypeDescription,
            onPressed: (EstateType? value) {
              widget.filters.estateType = value;
              if (value != EstateType.apartment) {
                widget.filters.apartmentType = null;
              }
              setState(() {
                _isApartment = value == EstateType.apartment;
              });
            },
            icons: const [
              CustomIcons.apartment,
              CustomIcons.house,
            ],
          ),
        ),
        Visibility(
          visible: _isApartment,
          child: ToggleFormField<ApartmentType>(
            values: ApartmentType.values,
            initialValue: widget.filters.apartmentType,
            getDescription: apartmentTypeDescription,
            onPressed: (ApartmentType? value) {
              widget.filters.apartmentType = value;
            },
            icons: const [
              CustomIcons.newbuilding,
              CustomIcons.secondarybuilding,
            ],
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        RangeField(
          title: AppLocalizations.of(context)!.price,
          icon: CustomIcons.money,
          initialValueFrom: widget.filters.priceMin != 0
              ? widget.filters.priceMin?.toString()
              : null,
          keyboardTypeFrom: TextInputType.number,
          inputFormattersFrom: [FilteringTextInputFormatter.digitsOnly],
          initialValueTo: widget.filters.priceMax != 0
              ? widget.filters.priceMax?.toString()
              : null,
          keyboardTypeTo: TextInputType.number,
          inputFormattersTo: [FilteringTextInputFormatter.digitsOnly],
          onChangedFrom: (value) {
            widget.filters.priceMin =
                value?.isEmpty ?? true ? null : int.parse(value!);
          },
          onChangedTo: (value) {
            widget.filters.priceMax =
                value?.isEmpty ?? true ? null : int.parse(value!);
          },
        ),
        RangeField(
          title: AppLocalizations.of(context)!.rooms,
          icon: CustomIcons.door,
          initialValueFrom: widget.filters.roomsMin != 0
              ? widget.filters.roomsMin?.toString()
              : null,
          keyboardTypeFrom: TextInputType.number,
          inputFormattersFrom: [FilteringTextInputFormatter.digitsOnly],
          initialValueTo: widget.filters.roomsMax != 0
              ? widget.filters.roomsMax?.toString()
              : null,
          keyboardTypeTo: TextInputType.number,
          inputFormattersTo: [FilteringTextInputFormatter.digitsOnly],
          onChangedFrom: (value) {
            widget.filters.roomsMin =
                value?.isEmpty ?? true ? null : int.parse(value!);
          },
          onChangedTo: (value) {
            widget.filters.roomsMax =
                value?.isEmpty ?? true ? null : int.parse(value!);
          },
        ),
      ],
    );
  }
}
