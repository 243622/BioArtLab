import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initNotification() async {
  AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('img');

  var initalizationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  var initialiaztionSettings = InitializationSettings(
    android: initializationSettingsAndroid, iOS: initalizationSettingsIOS);

  await notificationsPlugin.initialize(
      initialiaztionSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {}
  );
}
notificationDetails(){
  return const NotificationDetails(
    android: AndroidNotificationDetails("channelId", "channelName", importance: Importance.max),
    iOS: DarwinNotificationDetails()
  );
}

Future showNotification(int id, String? title, String? body, String? payload) async {
  print("Showing notification with id: $id, title: $title, body: $body");
  return notificationsPlugin.show(id, title, body, await notificationDetails());
}
}