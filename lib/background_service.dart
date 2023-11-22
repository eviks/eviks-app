import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:eviks_mobile/models/notification_data.dart';
import 'package:eviks_mobile/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundService {
  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    service.invoke('setAsBackground');

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        onBackground: onIosBackground,
      ),
    );

    service.startService();
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

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

  Timer.periodic(const Duration(hours: 2, minutes: 30), (timer) async {
    final lastRunTime = await getLastRunTime();
    final nextRunTime =
        generateRandomTime(lastRunTime.add(const Duration(days: 1)));
    final now = DateTime.now().toLocal();

    if (now.isAfter(nextRunTime) && now.hour >= 12 && now.hour <= 21) {
      saveLastRunTime(now);

      if (service is AndroidServiceInstance) {
        final data = NotificationData(
          body: 'Hello',
          title: 'Test',
          payload: '{"type": "subscription"}',
        );
        NotificationService().showNotification(
          data,
        );
      }
    }
  });
}

DateTime generateRandomTime(DateTime nextRunTime) {
  final randomHour = Random().nextInt(10) + 12;
  final randomMinute = Random().nextInt(60);

  return DateTime(
    nextRunTime.year,
    nextRunTime.month,
    nextRunTime.day,
    randomHour,
    randomMinute,
  );
}

Future<DateTime> getLastRunTime() async {
  final prefs = await SharedPreferences.getInstance();
  final lastRunTimeString = prefs.getString('lastSubscriptionNotification');

  if (lastRunTimeString == null) {
    return DateTime(2023);
  }

  return DateTime.parse(lastRunTimeString);
}

Future<void> saveLastRunTime(DateTime time) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(
    'lastSubscriptionNotification',
    time.toIso8601String(),
  );
}
