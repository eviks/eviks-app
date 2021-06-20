import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/post_item.dart';

class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home),
            SizedBox(
              width: 5,
            ),
            Text(AppLocalizations.of(context)!.postsScreenTitle),
          ],
        ),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, builder) {
          return PostItem();
        },
        itemCount: 5,
      ),
    );
  }
}
