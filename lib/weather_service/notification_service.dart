import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // =========================
  // INITIALIZE NOTIFICATIONS
  // =========================
  Future<void> initialize() async {
    print("=== NOTIFICATION SERVICE STARTED ===");

    // 1. Request notification permission
    NotificationSettings settings =
        await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print(
      "Permission: ${settings.authorizationStatus}",
    );

    // 2. Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
    );

    // 3. Create notification channel
    const AndroidNotificationChannel channel =
        AndroidNotificationChannel(
      'weather_channel',
      'Weather Notifications',
      description: 'Weather app notifications',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    print("Notification Channel Created");

    // 4. Get FCM Token
    String? token = await _messaging.getToken();

    print("FCM TOKEN => $token");

    // 5. Save token to Firestore
    if (token != null) {
      await FirebaseFirestore.instance
          .collection('tokens')
          .doc(token)
          .set({
        "token": token,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }

    // 6. Subscribe to weather topic
    await _messaging.subscribeToTopic('weather');

    print("Subscribed to weather topic");

    // 7. Receive FCM notification while app is open
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        print("=== FOREGROUND MESSAGE ===");

        print(
          "Title: ${message.notification?.title}",
        );

        print(
          "Body: ${message.notification?.body}",
        );

        try {
          await _localNotifications.show(
            id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            title:
                message.notification?.title ??
                "Weather Update",
            body:
                message.notification?.body ??
                "New Weather Alert",
            notificationDetails:
                const NotificationDetails(
              android: AndroidNotificationDetails(
                'weather_channel',
                'Weather Notifications',
                channelDescription:
                    'Weather app notifications',
                importance: Importance.max,
                priority: Priority.max,
              ),
            ),
          );

          print("LOCAL NOTIFICATION SHOWN");
        } catch (e) {
          print(
            "LOCAL NOTIFICATION ERROR => $e",
          );
        }
      },
    );

    // 8. When user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print("=== NOTIFICATION OPENED ===");

        print(
          "Title: ${message.notification?.title}",
        );
      },
    );
  }

  // =========================
  // SHOW WEATHER NOTIFICATION
  // =========================
  Future<void> showWeatherNotification({
    required double temperature,
    required String description,
  }) async {
    try {
      await _localNotifications.show(
        id: 100,
        title: "Today's Weather",
        body:
            "${temperature.round()}°C, $description",
        notificationDetails:
            const NotificationDetails(
          android: AndroidNotificationDetails(
            'weather_channel',
            'Weather Notifications',
            channelDescription:
                'Daily weather notifications',
            importance: Importance.max,
            priority: Priority.max,
          ),
        ),
      );

      print("=== WEATHER NOTIFICATION SHOWN ===");
      print(
        "Temperature: ${temperature.round()}°C",
      );
      print(
        "Description: $description",
      );
    } catch (e) {
      print(
        "WEATHER NOTIFICATION ERROR => $e",
      );
    }
  }
}