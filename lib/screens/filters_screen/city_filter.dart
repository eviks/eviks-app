import 'package:eviks_mobile/models/settlement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/posts.dart';
import '../../widgets/selections/city_selection.dart';

class CityFilter extends StatelessWidget {
  const CityFilter({Key? key}) : super(key: key);

  Future<void> _selectCity(BuildContext context) async {
    final city = await Navigator.push<Settlement?>(
      context,
      MaterialPageRoute(builder: (context) => const CitySelection()),
    );

    if (city != null) {
      Provider.of<Posts>(context, listen: false).updateFilters({
        'city': city,
        'districts': null,
        'subdistricts': null,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${AppLocalizations.of(context)!.city}: ',
          style: const TextStyle(fontSize: 18.0),
        ),
        TextButton(
          onPressed: () {
            _selectCity(context);
          },
          child: Consumer<Posts>(
            builder: (context, posts, child) => Text(
              posts.filters.city.getLocalizedName(context),
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      ],
    );
  }
}
