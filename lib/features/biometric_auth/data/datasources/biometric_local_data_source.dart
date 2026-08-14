import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricLocalDataSource {
  BiometricLocalDataSource({required this.localAuth});

  final LocalAuthentication localAuth;

  static const _secure = FlutterSecureStorage();
  static const _securePhoneKey = 'biometric_phone';
  static const _securePasswordKey = 'biometric_password';

  Future<bool> canCheckBiometrics() async {
    try {
      final bool canCheck = await localAuth.canCheckBiometrics;
      final bool isSupported = await localAuth.isDeviceSupported();
      return canCheck && isSupported;
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await localAuth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }

  Future<bool> authenticate() async {
    try {
      return await localAuth.authenticate(
        localizedReason: 'قم بالمصادقة لتسجيل الدخول',
        biometricOnly: true,
      );
    } on LocalAuthException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> saveBiometricEnabled(bool enabled) =>
      SharedPrefs.saveBiometricEnabled(enabled);

  Future<bool> isBiometricEnabled() => SharedPrefs.isBiometricEnabled();

  /// Feature 8 — credentials for post-logout biometric login (not SharedPrefs).
  Future<void> saveCredentials({
    required String phone,
    required String password,
  }) async {
    await _secure.write(key: _securePhoneKey, value: phone.trim());
    await _secure.write(key: _securePasswordKey, value: password);
  }

  Future<({String phone, String password})?> readCredentials() async {
    final phone = await _secure.read(key: _securePhoneKey);
    final password = await _secure.read(key: _securePasswordKey);
    if (phone == null ||
        phone.isEmpty ||
        password == null ||
        password.isEmpty) {
      return null;
    }
    return (phone: phone, password: password);
  }

  Future<bool> hasCredentials() async {
    return await readCredentials() != null;
  }

  Future<void> clearCredentials() async {
    await _secure.delete(key: _securePhoneKey);
    await _secure.delete(key: _securePasswordKey);
  }
}
