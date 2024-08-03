import 'package:eviks_mobile/models/settlement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/filters.dart';
import '../../providers/posts.dart';
import '../../widgets/selections/district_selection.dart';
import '../../widgets/tag.dart';

class DistrictFilter extends StatefulWidget {
  const DistrictFilter({Key? key}) : super(key: key);

  @override
  State<DistrictFilter> createState() => _DistrictFilterState();
}

class _DistrictFilterState extends State<DistrictFilter> {
  Future<void> _selectDistrict(BuildContext context) async {
    final Filters filters = Provider.of<Posts>(context, listen: false).filters;
    final result = await Navigator.push<Map<String, List<Settlement>>?>(
      context,
      MaterialPageRoute(
        builder: (context) => DistrictSelection(
          city: filters.city,
          selectedDistricts: filters.districts ?? [],
          selectedSubdistricts: filters.subdistricts ?? [],
        ),
      ),
    );
    if (result != null) {
      if (!mounted) return;
      Provider.of<Posts>(context, listen: false).updateFilters({
        'districts': result['districts'],
        'subdistricts': result['subdistricts'],
      });
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
        Consumer<Posts>(
          builder: (context, posts, child) => Wrap(
            children: posts.filters.districts
                    ?.map(
                      (district) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Tag(
                          key: Key(district.id),
                          label: district.getLocalizedName(context),
                          icon: Icons.close,
                          onPressed: () {
                            Provider.of<Posts>(context, listen: false)
                                .updateFilters(
                              {
                                'districts': posts.filters.districts
                                    ?.where(
                                      (element) => element.id != district.id,
                                    )
                                    .toList(),
                              },
                            );
                          },
                        ),
                      ),
                    )
                    .toList() ??
                [],
          ),
        ),
        Consumer<Posts>(
          builder: (context, posts, child) => Wrap(
            children: posts.filters.subdistricts
                    ?.map(
                      (subdistrict) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Tag(
                          key: Key(subdistrict.id),
                          label: subdistrict.getLocalizedName(context),
                          icon: Icons.close,
                          onPressed: () {
                            Provider.of<Posts>(context, listen: false)
                                .updateFilters(
                              {
                                'subdistricts': posts.filters.subdistricts
                                    ?.where(
                                      (element) => element.id != subdistrict.id,
                                    )
                                    .toList(),
                              },
                            );
                          },
                        ),
                      ),
                    )
                    .toList() ??
                [],
          ),
        ),
      ],
    );
  }
}
