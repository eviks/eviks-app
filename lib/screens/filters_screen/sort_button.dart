import 'package:eviks_mobile/models/filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/posts.dart';
import './sort_modal.dart';

class SortButton extends StatefulWidget {
  const SortButton({Key? key}) : super(key: key);

  @override
  State<SortButton> createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  @override
  Widget build(BuildContext context) {
    final sort = Provider.of<Posts>(context).filters.sort;

    return Row(
      children: [
        Text(
          '${AppLocalizations.of(context)!.sort}: ',
        ),
        TextButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              builder: (BuildContext context) {
                return const SortModal();
              },
            );
          },
          child: Text(sortDescription(sort, context)),
        ),
      ],
    );
  }
}
