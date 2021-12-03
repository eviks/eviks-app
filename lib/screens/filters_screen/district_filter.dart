import 'package:eviks_mobile/models/settlement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/filters.dart';
import '../../widgets/selections/district_selection.dart';
import '../../widgets/tag.dart';

class DistrictFilter extends StatelessWidget {
  final Filters filters;
  final Function updateState;
  const DistrictFilter(
      {required this.filters, required this.updateState, Key? key})
      : super(key: key);

  void _selectDistrict(BuildContext context) async {
    final result = await Navigator.push<Map<String, List<Settlement>>?>(
      context,
      MaterialPageRoute(
          builder: (context) => DistrictSelection(
                city: filters.city,
                selectedDistricts: filters.districts ?? [],
                selectedSubdistricts: filters.subdistricts ?? [],
              )),
    );
    if (result != null) {
      filters.districts = result['districts'];
      filters.subdistricts = result['subdistricts'];
      updateState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
        ),
        Wrap(
          children: filters.districts
                  ?.map(
                    (district) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Tag(
                        key: Key(district.id),
                        label: district.name,
                        icon: Icons.close,
                        onPressed: () {
                          filters.districts?.removeWhere(
                              (element) => element.id == district.id);
                          updateState();
                        },
                      ),
                    ),
                  )
                  .toList() ??
              [],
        ),
        Wrap(
          children: filters.subdistricts
                  ?.map(
                    (subdistrict) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Tag(
                        key: Key(subdistrict.id),
                        label: subdistrict.name,
                        icon: Icons.close,
                        onPressed: () {
                          filters.subdistricts?.removeWhere(
                              (element) => element.id == subdistrict.id);
                          updateState();
                        },
                      ),
                    ),
                  )
                  .toList() ??
              [],
        )
      ],
    );
  }
}
