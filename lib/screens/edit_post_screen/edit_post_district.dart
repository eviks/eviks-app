import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/settlement.dart';
import '../../widgets/selections/city_selection.dart';
import '../../widgets/selections/district_selection.dart';

class EditPostDistrict extends StatelessWidget {
  final Settlement city;
  final Settlement? district;
  final Settlement? subdistrict;
  final Function(Settlement) updateCity;
  final Function(Settlement, Settlement?) updateDistrict;

  const EditPostDistrict(
      {required this.city,
      this.district,
      this.subdistrict,
      required this.updateCity,
      required this.updateDistrict,
      Key? key})
      : super(key: key);

  Future<void> _selectCity(BuildContext context) async {
    final selectedCity = await Navigator.push<Settlement?>(
      context,
      MaterialPageRoute(builder: (context) => const CitySelection()),
    );

    if (selectedCity != null) {
      updateCity(selectedCity);
    }
  }

  Future<void> _selectDistrict(BuildContext context) async {
    final result = await Navigator.push<Map<String, List<Settlement>>?>(
      context,
      MaterialPageRoute(
          builder: (context) => DistrictSelection(
                city: city,
                selectedDistricts: const [],
                selectedSubdistricts: const [],
                selecMode: SubdistrictSelectMode.single,
              )),
    );

    if (result != null) {
      updateDistrict(
        result['districts']![0],
        result['subdistricts'] != null ? result['subdistricts']![0] : null,
      );
    }
  }

  String _getDistrictPresentation(BuildContext context) {
    String presentation = '';
    presentation = district?.getLocaliedName(context) ??
        AppLocalizations.of(context)!.districtNotSelected;
    if (district?.children?.isNotEmpty ?? false) {
      presentation =
          '$presentation, ${subdistrict?.getLocaliedName(context) ?? AppLocalizations.of(context)!.subdistrictNotSelected}';
    }
    return presentation;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettlementSelect(
          label: '${AppLocalizations.of(context)!.city}:',
          text: city.getLocaliedName(context),
          onTap: () {
            _selectCity(context);
          },
        ),
        SettlementSelect(
          label: '${AppLocalizations.of(context)!.district}:',
          text: _getDistrictPresentation(context),
          onTap: () {
            _selectDistrict(context);
          },
        ),
      ],
    );
  }
}

class SettlementSelect extends StatelessWidget {
  final String label;
  final String text;
  final void Function() onTap;

  const SettlementSelect(
      {required this.label, required this.text, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: onTap,
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
