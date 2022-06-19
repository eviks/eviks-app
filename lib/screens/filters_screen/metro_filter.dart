import 'package:eviks_mobile/models/metro_station.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/filters.dart';
import '../../providers/posts.dart';
import '../../widgets/selections/metro_selection.dart';
import '../../widgets/tag.dart';

class MetroFilter extends StatelessWidget {
  const MetroFilter({Key? key}) : super(key: key);

  Future<void> _selectMetro(BuildContext context) async {
    final Filters _filters = Provider.of<Posts>(context, listen: false).filters;
    final metroStations = await Navigator.push<List<MetroStation>?>(
      context,
      MaterialPageRoute(
          builder: (context) => MetroSelection(
                metroStations: _filters.city.metroStations ?? [],
                selectedMetroStations: _filters.metroStations ?? [],
              )),
    );

    if (metroStations != null) {
      Provider.of<Posts>(context, listen: false).updateFilters({
        'metroStations': metroStations,
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
                _selectMetro(context);
              },
              child: Text(
                AppLocalizations.of(context)!.metro,
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
        Consumer<Posts>(
          builder: (context, posts, child) => Wrap(
            children: posts.filters.metroStations
                    ?.map(
                      (metroStation) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Tag(
                          key: Key(metroStation.id.toString()),
                          label: metroStation.getLocalizedName(context),
                          icon: Icons.close,
                          onPressed: () {
                            Provider.of<Posts>(context, listen: false)
                                .updateFilters(
                              {
                                'metroStations': posts.filters.metroStations
                                    ?.where(
                                      (element) =>
                                          element.id != metroStation.id,
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
