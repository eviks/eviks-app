import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:eviks_mobile/icons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './constants.dart';
import './models/navigation_service.dart';
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
import '../screens/post_review_screen/post_review_screen.dart';

@pragma('vm:entry-point')
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

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationService().initNotification();
  await initializeService();

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

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  service.invoke('setAsBackground');

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        print(1);
      }
    }
  });
}
