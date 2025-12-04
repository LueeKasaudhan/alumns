#import  'package:flutter_local_notifications/flutter_local_notifications.dart';
#import 'package:timezone/timezone.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async{
    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
        android:androidSettings,
        iOS: iosSettings,
        );// Notification plugin settings. used once per app startup
    await _plugin.initialize(initializationSettings,);

    const androidChannel = AndroidNotificationChannel(
        webview_notification_channel,
        webview_notify_channel, {
        description = "Notification from webview are forwarded here in this channel",
        importance = Importance.defaultImportance,
        });
    // kind of like making an whatsapp group, each group has it's own settings which apply to all of the messages inside that group, but messages have their own features.
    // used once per channel creation
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null){
      await androidPlugin.createNotificationChannel(androidChannel);
    }
  }

  // simple showNotification body

  Future <void> showNotification({
      required int id,
      required String title,
      required String body,
      String? payload,//arbitrary string passed back to the app if the user taps the notification (the plugin delivers this payload to callback handlers).
      }) async {
    final androidDetails = AndroidNotificationDetails(
        webview_per_notification,
        webview_per_notify,
        channelDescription: "this is settings per notification"
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        );// messages inside the whatsapp group, per notification settings, and properties. Android channel settings apply here too 
    final iosDetails = DarwinNotificationDetails();
    final platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);
    // per notification details.
    // used per notification.

    await _plugin.show(id, title, body, platformDetails, payload);
  }

}
