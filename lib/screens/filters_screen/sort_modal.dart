import 'package:eviks_mobile/models/filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/posts.dart';

class SortModal extends StatefulWidget {
  const SortModal({Key? key}) : super(key: key);

  @override
  State<SortModal> createState() => _SortModalState();
}

class _SortModalState extends State<SortModal> {
  @override
  Widget build(BuildContext context) {
    final sort = Provider.of<Posts>(context).filters.sort;

    void updateFilters(SortType? value) {
      Provider.of<Posts>(context, listen: false).updateFilters({"sort": value});
      Navigator.pop(context);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: [
          Column(
            children: [
              RadioListTile(
                title: Text(AppLocalizations.of(context)!.priceAsc),
                value: SortType.priceAsc,
                groupValue: sort,
                onChanged: updateFilters,
              ),
              RadioListTile(
                title: Text(AppLocalizations.of(context)!.priceDsc),
                value: SortType.priceDsc,
                groupValue: sort,
                onChanged: updateFilters,
              ),
              RadioListTile(
                title: Text(AppLocalizations.of(context)!.sqmAsc),
                value: SortType.sqmAsc,
                groupValue: sort,
                onChanged: updateFilters,
              ),
              RadioListTile(
                title: Text(AppLocalizations.of(context)!.sqmDsc),
                value: SortType.sqmDsc,
                groupValue: sort,
                onChanged: updateFilters,
              ),
              RadioListTile(
                title: Text(AppLocalizations.of(context)!.dateAsc),
                value: SortType.dateAsc,
                groupValue: sort,
                onChanged: updateFilters,
              ),
              RadioListTile(
                title: Text(AppLocalizations.of(context)!.dateDsc),
                value: SortType.dateDsc,
                groupValue: sort,
                onChanged: updateFilters,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
