import 'dart:io';

import 'package:eviks_mobile/icons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './constants.dart';
import './notification_service.dart';
import './providers/auth.dart';
import './providers/locale_provider.dart';
import './providers/localities.dart';
import './providers/posts.dart';
import './providers/subscriptions.dart';
import './providers/theme_preferences.dart';
import './screens/auth_screen/auth_screen.dart';
import './screens/edit_post_screen/edit_post_screen.dart';
import './screens/filters_screen/filters_screen.dart';
import './screens/post_detail_screen/post_detail_screen.dart';
import './screens/reset_password_screen/reset_password_screen.dart';
import './screens/tabs_screen.dart';
import '../models/notification_data.dart';
import './models/navigation_service.dart';
import '../screens/post_review_screen/post_review_screen.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    final data = NotificationData.fromJson(json: message.data);

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    if (data.user != null && userId != data.user) {
      return;
    }

    NotificationService().showNotification(
      data,
    );
  } catch (error) {
    //
  }
}

Future main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  final themeMode = await getThemePreferences();
  final locale = await getLocale();

  final mySystemTheme = themeMode == ThemeMode.dark
      ? SystemUiOverlayStyle.dark
      : SystemUiOverlayStyle.light;
  SystemChrome.setSystemUIOverlayStyle(mySystemTheme);

  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  NotificationService().initNotification();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(
    MyApp(
      themeMode: themeMode,
      locale: locale,
    ),
  );
}

Future<ThemeMode> getThemePreferences() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString('themeMode') ?? 'system';

    return ThemeMode.values.firstWhere(
      (element) => element.toString() == 'ThemeMode.$savedThemeMode',
    );
  } catch (error) {
    return ThemeMode.system;
  }
}

Future<Locale> getLocale() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale') ?? 'az';

    if (!AppLocalizations.supportedLocales.contains(Locale(savedLocale))) {
      return const Locale('az');
    }

    return Locale(savedLocale);
  } catch (error) {
    return const Locale('az');
  }
}

class MyApp extends StatelessWidget {
  final ThemeMode? themeMode;
  final Locale? locale;

  const MyApp({this.themeMode, this.locale});

  @override
  Widget build(BuildContext context) {
    Widget getHomePage() {
      FlutterNativeSplash.remove();
      return TabsScreen();
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Posts>(
          create: (ctx) =>
              Posts('', '', [], null, initFilters(), initPagination(), []),
          update: (ctx, auth, previousPosts) => Posts(
            auth.token,
            auth.user?.id ?? '',
            previousPosts?.posts ?? [],
            previousPosts?.postData,
            previousPosts?.filters ?? initFilters(),
            previousPosts?.pagination ?? initPagination(),
            previousPosts?.postsLocations ?? [],
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Subscriptions>(
          create: (ctx) => Subscriptions('', []),
          update: (ctx, auth, previousSubscriptions) => Subscriptions(
            auth.token,
            previousSubscriptions?.subscriptions ?? [],
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => Localities()),
        ChangeNotifierProvider(
          create: (ctx) => ThemePreferences(themeMode ?? ThemeMode.system),
        ),
        ChangeNotifierProvider(
          create: (ctx) => LocaleProvider(
            locale ?? const Locale('az'),
          ),
        ),
      ],
      child: Consumer3<Auth, ThemePreferences, LocaleProvider>(
        builder: (ctx, auth, themePreferences, localeProvider, _) =>
            MaterialApp(
          navigatorKey: NavigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Eviks',
          locale: localeProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          themeMode: themePreferences.themeMode,
          theme: lightThemeData(context),
          darkTheme: darkThemeData(context),
          home: auth.isAuth
              ? getHomePage()
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
                          : getHomePage(),
                ),
          routes: {
            TabsScreen.routeName: (ctx) => TabsScreen(),
            PostDetailScreen.routeName: (ctx) => const PostDetailScreen(),
            AuthScreen.routeName: (ctx) => const AuthScreen(),
            EditPostScreen.routeName: (ctx) => const EditPostScreen(),
            FiltersScreen.routeName: (ctx) => const FiltersScreen(),
            ResetPasswordScreen.routeName: (ctx) => const ResetPasswordScreen(),
            PostReviewScreen.routeName: (ctx) => const PostReviewScreen(),
          },
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
