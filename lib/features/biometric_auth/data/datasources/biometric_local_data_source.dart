import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:local_auth/local_auth.dart';

class BiometricLocalDataSource {
  final LocalAuthentication localAuth;
  BiometricLocalDataSource({required this.localAuth});

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

  Future<void> saveBiometricEnabled(bool enabled) => SharedPrefs.saveBiometricEnabled(enabled);
  Future<bool> isBiometricEnabled() => SharedPrefs.isBiometricEnabled();
}