import 'package:eviks_mobile/icons.dart';
import 'package:eviks_mobile/providers/theme_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './constants.dart';
import './providers/auth.dart';
import './providers/localities.dart';
import './providers/posts.dart';
import './providers/theme_preferences.dart';
import './screens/auth_screen/auth_screen.dart';
import './screens/edit_post_screen/edit_post_screen.dart';
import './screens/filters_screen/filters_screen.dart';
import './screens/post_detail_screen/post_detail_screen.dart';
import './screens/tabs_screen.dart';
import './screens/verification_screen.dart';
import './theme.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final themeMode = await getThemePreferences();
  runApp(MyApp(
    themeMode: themeMode,
  ));
}

Future<ThemeMode> getThemePreferences() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString('themeMode') ?? 'system';

    return ThemeMode.values.firstWhere(
        (element) => element.toString() == 'ThemeMode.$savedThemeMode');
  } catch (error) {
    return ThemeMode.system;
  }
}

class MyApp extends StatelessWidget {
  final ThemeMode? themeMode;

  const MyApp({this.themeMode});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Posts>(
          create: (ctx) => Posts('', [], null, initFilters(), initPagination()),
          update: (ctx, auth, previousPosts) => Posts(
            auth.token,
            previousPosts?.posts ?? [],
            previousPosts?.postData,
            previousPosts?.filters ?? initFilters(),
            previousPosts?.pagination ?? initPagination(),
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => Localities()),
        ChangeNotifierProvider(
            create: (ctx) => ThemePreferences(themeMode ?? ThemeMode.system)),
      ],
      child: Consumer2<Auth, ThemePreferences>(
        builder: (ctx, auth, themePreferences, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Eviks',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          themeMode: themePreferences.themeMode,
          theme: lightThemeData(context),
          darkTheme: darkThemeData(context),
          home: auth.isAuth
              ? TabsScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? Scaffold(
                              backgroundColor: primaryColor,
                              body: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      CustomIcons.logo,
                                      color: lightColor,
                                      size: 52.0,
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      'Eviks',
                                      style: TextStyle(
                                        color: lightColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : TabsScreen(),
                ),
          routes: {
            TabsScreen.routeName: (ctx) => TabsScreen(),
            PostDetailScreen.routeName: (ctx) => const PostDetailScreen(),
            VerificationScreen.routeName: (ctx) => const VerificationScreen(),
            AuthScreen.routeName: (ctx) => const AuthScreen(),
            EditPostScreen.routeName: (ctx) => const EditPostScreen(),
            FiltersScreen.routeName: (ctx) => const FiltersScreen(),
          },
        ),
      ),
    );
  }
}
