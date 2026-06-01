import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Top-level handler required by firebase_messaging for background messages.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background messages are shown automatically by FCM on Android.
  // No additional handling needed here for basic notifications.
}

class FcmService {
  static final _messaging = FirebaseMessaging.instance;
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  static const _channelId = 'fccu_societies_hub';
  static const _channelName = 'FCCU Societies Hub';

  static Future<void> initialize() async {
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Set up Android notification channel for foreground messages
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    // Request permission (iOS / Android 13+)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle foreground messages by showing a local notification
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    });
  }

  /// Save/refresh the FCM token in the user's Firestore document.
  static Future<void> saveToken(String userId) async {
    final token = await _messaging.getToken();
    if (token == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'fcmToken': token});

    // Refresh on token rotation
    _messaging.onTokenRefresh.listen((newToken) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'fcmToken': newToken});
    });
  }
}
