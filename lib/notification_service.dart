import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Almaty'));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await notifications.initialize(settings: settings);

    const androidChannel = AndroidNotificationChannel(
      'task_channel',
      'Tasks',
      description: 'Task reminders',
      importance: Importance.max,
    );

    await notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    await notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> showNow() async {
    await notifications.show(
      id: 100,
      title: 'TEST NOW',
      body: 'Уведомление работает',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Tasks',
          channelDescription: 'Task reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
