import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/posts.dart';
import './screens/post_detail_screen/post_detail_screen.dart';
import './screens/tabs_screen.dart';
import './screens/verification_screen.dart';
import './theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Posts>(
          create: (ctx) => Posts('', []),
          update: (ctx, auth, previousPosts) => Posts(auth.token, []),
        ),
      ],
      child: MaterialApp(
        title: 'Eviks',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        initialRoute: '/',
        routes: {
          TabsScreen.routeName: (ctx) => TabsScreen(),
          PostDetailScreen.routeName: (ctx) => const PostDetailScreen(),
          VerificationScreen.routeName: (ctx) => const VerificationScreen(),
        },
      ),
    );
  }
}
