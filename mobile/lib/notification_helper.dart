import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();
  
  static init(){
    _notification.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@drawable/app_icon'),
      iOS: DarwinInitializationSettings()
    ));
    tz.initializeTimeZones();

  }

  static scheduledNotification(String title, String body, DateTime scheduledDate) async {
    var androidDetails = AndroidNotificationDetails(
        'important_notifications',
        'My Channel',
        importance: Importance.max,
        priority: Priority.high);

    var iosDetails = DarwinNotificationDetails();

    var notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notification.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local), // Chuyển đổi DateTime sang TZDateTime
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static scheduleWorkoutdNotification(String title, String body, DateTime scheduledDate) async {
    var androidDetails = AndroidNotificationDetails(
        'important_notifications',
        'My Channel',
        importance: Importance.max,
        priority: Priority.high);

    var iosDetails = DarwinNotificationDetails();

    var notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notification.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local), // Chuyển đổi DateTime sang TZDateTime
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }


}