import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/localities.dart';
import './providers/posts.dart';
import './screens/auth_screen/auth_screen.dart';
import './screens/edit_post_screen/edit_post_screen.dart';
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
          update: (ctx, auth, previousPosts) => Posts(
            auth.token,
            previousPosts == null ? [] : previousPosts.posts,
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => Localities()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Eviks',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: lightThemeData(context),
          darkTheme: darkThemeData(context),
          home: auth.isAuth
              ? TabsScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const Text('Loading...')
                          : TabsScreen(),
                ),
          routes: {
            TabsScreen.routeName: (ctx) => TabsScreen(),
            PostDetailScreen.routeName: (ctx) => const PostDetailScreen(),
            VerificationScreen.routeName: (ctx) => const VerificationScreen(),
            AuthScreen.routeName: (ctx) => const AuthScreen(),
            EditPostScreen.routeName: (ctx) => const EditPostScreen(),
          },
        ),
      ),
    );
  }
}
