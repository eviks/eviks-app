import 'package:eviks_mobile/models/settlement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/filters.dart';
import '../city_selection_screen.dart';

class CityFilter extends StatelessWidget {
  final Filters filters;
  final Function updateState;
  const CityFilter({required this.filters, required this.updateState, Key? key})
      : super(key: key);

  void _selectCity(BuildContext context) async {
    final result = await Navigator.push<Settlement?>(
      context,
      MaterialPageRoute(builder: (context) => const SelectionScreen()),
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
          '${AppLocalizations.of(context)!.city}: ',
          style: const TextStyle(fontSize: 18.0),
        ),
        TextButton(
          onPressed: () {
            _selectCity(context);
          },
          child: Text(
            filters.city.name,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
      ],
    );
  }
}
