import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './favorites.dart';
import './subscriptions.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: AppLocalizations.of(context)!.posts),
              Tab(text: AppLocalizations.of(context)!.subscriptions),
            ],
          ),
          leading: Navigator.canPop(context)
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(CustomIcons.back),
                )
              : null,
          title: Text(
            AppLocalizations.of(context)!.favorites,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [Favorites(), Subscriptions()],
        ),
      ),
    );
  }
}
