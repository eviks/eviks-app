import 'package:eviks_mobile/models/settlement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/filters.dart';
import '../../widgets/selections/district_selection.dart';

class DistrictFilter extends StatelessWidget {
  final Filters filters;
  final Function updateState;
  const DistrictFilter(
      {required this.filters, required this.updateState, Key? key})
      : super(key: key);

  void _selectDistrict(BuildContext context) async {
    final result = await Navigator.push<Settlement?>(
      context,
      MaterialPageRoute(
          builder: (context) => DistrictSelection(
                city: filters.city,
                selectedDistricts: filters.distrcits ?? [],
                selectedSubdistricts: filters.subdistrcits ?? [],
              )),
    );
    if (result != null) {
      filters.city = result;
      updateState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${AppLocalizations.of(context)!.specifyArea}: ',
          style: const TextStyle(fontSize: 18.0),
        ),
        TextButton(
          onPressed: () {
            _selectDistrict(context);
          },
          child: Text(
            AppLocalizations.of(context)!.district,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
      ],
    );
  }
}
