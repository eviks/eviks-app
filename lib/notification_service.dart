import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './constants.dart';
import './models/navigation_service.dart';
import './models/notification_data.dart';
import './models/notification_payload.dart';
import './models/pages_payload.dart';
import './screens/tabs_screen.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    final didNotificationLaunchApp =
        notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

    if (didNotificationLaunchApp) {
      final notificationResponse =
          notificationAppLaunchDetails!.notificationResponse;
      if (notificationResponse != null) {
        onSelectNotification(notificationResponse);
      }
    } else {
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onSelectNotification,
        onDidReceiveBackgroundNotificationResponse: onSelectNotification,
      );
    }

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground',
      'MY FOREGROUND SERVICE',
      description: 'This channel is used for important notifications.',
      importance: Importance.low,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<NotificationDetails> notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        color: primaryColor,
        styleInformation: BigTextStyleInformation(''),
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future showNotification(
    NotificationData data,
  ) async {
    return flutterLocalNotificationsPlugin.show(
      Random().nextInt(1000),
      data.title,
      data.body,
      await notificationDetails(),
      payload: data.payload,
    );
  }
}

Future<void> onSelectNotification(
  NotificationResponse notificationResponse,
) async {
  if (notificationResponse.payload == null) {
    return;
  }
  final payload = NotificationPayload.fromJson(
    json: json.decode(notificationResponse.payload ?? ''),
  );
  if (payload.type == NotificationPayloadType.subscription) {
    Navigator.of(NavigationService.navigatorKey.currentContext!)
        .pushNamedAndRemoveUntil(
      TabsScreen.routeName,
      (route) => false,
      arguments: PagesPayload(Pages.favorites, {'tab': 1}),
    );
  }
}
