import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import './providers/posts.dart';
import './screens/tabs_screen.dart';
import './theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Posts([])),
      ],
      child: MaterialApp(
        title: 'Eviks',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        home: TabsScreen(),
      ),
    );
  }
}
