import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/features/notifications/data/datasources/device_token_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Registers / unregisters FCM device token with the backend.
class DeviceTokenSync {
  DeviceTokenSync._();

  static DeviceTokenRemoteDataSource get _ds => DeviceTokenRemoteDataSource(
        api: DioConsumer(dio: Dio()),
      );

  static const String androidPlatform = 'ANDROID';

  /// Call once a session is ready (auth token present). Safe to call often.
  static Future<void> registerCurrentToken() async {
    final auth = await SharedPrefs.getToken();
    if (auth == null || auth.trim().isEmpty) return;

    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;

      final previous = await SharedPrefs.getFcmToken();
      if (previous != null &&
          previous.isNotEmpty &&
          previous != token) {
        try {
          await _ds.deleteToken(token: previous);
        } catch (_) {
          // Best-effort cleanup of rotated token.
        }
      }

      await _ds.registerToken(token: token, platform: androidPlatform);
      await SharedPrefs.saveFcmToken(token);
      debugPrint('FCM device-token registered with backend');
    } catch (e) {
      debugPrint('FCM device-token register failed: $e');
    }
  }

  /// Call on logout / session end. Then POST again on next login.
  static Future<void> unregisterCurrentToken() async {
    final token = await SharedPrefs.getFcmToken() ??
        await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) {
      await SharedPrefs.clearFcmToken();
      return;
    }

    try {
      await _ds.deleteToken(token: token);
      debugPrint('FCM device-token deleted from backend');
    } catch (e) {
      debugPrint('FCM device-token delete failed: $e');
    } finally {
      await SharedPrefs.clearFcmToken();
    }
  }
}
