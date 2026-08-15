import 'package:dental_app/core/notifications/device_token_sync.dart';
import 'package:dental_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Top-level — required for FCM background isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint(
    'FCM background: ${message.messageId} '
    'title=${message.notification?.title}',
  );
}

/// Permission + FCM token + foreground local notifications (Android channel).
class PushNotificationService {
  PushNotificationService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important notifications.',
    importance: Importance.high,
  );

  static Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _initLocalNotifications();
    await _requestPermission();

    final token = await _messaging.getToken();
    debugPrint('FCM token: $token');

    _messaging.onTokenRefresh.listen((newToken) async {
      debugPrint('FCM token refresh: $newToken');
      // Re-register with backend when FCM rotates (if logged in).
      await DeviceTokenSync.registerCurrentToken();
    });

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint(
        'FCM opened from background: ${message.messageId} '
        'title=${message.notification?.title}',
      );
    });

    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      debugPrint(
        'FCM opened from terminated: ${initial.messageId} '
        'title=${initial.notification?.title}',
      );
    }
  }

  static Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _local.initialize(settings: initSettings);

    final androidPlugin = _local.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_androidChannel);
  }

  static Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final androidPlugin = _local.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> _onForegroundMessage(RemoteMessage message) async {
    debugPrint(
      'FCM foreground: ${message.messageId} '
      'title=${message.notification?.title}',
    );

    final notification = message.notification;
    if (notification == null) return;

    await _local.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data.isEmpty ? null : message.data.toString(),
    );
  }
}
