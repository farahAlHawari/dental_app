import 'package:dartz/dartz.dart';
import 'package:dental_app/core/api/end_points.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/features/biometric_auth/data/datasources/biometric_remote_data_source.dart';
import 'package:dental_app/features/biometric_auth/data/datasources/biometric_local_data_source.dart';
import 'biometric_repository.dart';

class BiometricRepositoryImpl extends BiometricRepository {
  final BiometricRemoteDataSource remoteDataSource;
  final BiometricLocalDataSource localDataSource;

  BiometricRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, bool>> setBiometricEnabled(bool enabled) async {
    try {
      final result = await remoteDataSource.setBiometricStatus(enabled: enabled);
      final success = result['success'] == true;

      if (success) {
        await localDataSource.saveBiometricEnabled(enabled);
      }
      return Right(success);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }
@override
Future<bool> validateSession() async {
  try {
    
    await remoteDataSource.api.get(EndPoints.patientsMy);
    return true;
  } catch (_) {
    // فشل نهائياً (حتى بعد محاولة الـ refresh التلقائي بالـ interceptor)
    await SharedPrefs.clearTokens(); // بتمسح البصمة كمان تلقائياً بفضل التعديل يلي عملناه
    return false;
  }
}
 @override
Future<bool> canUseBiometrics() async {
  final enabledLocally = await localDataSource.isBiometricEnabled();
  if (!enabledLocally) return false;

  final deviceSupports = await localDataSource.canCheckBiometrics();
  if (!deviceSupports) return false;

  final available = await localDataSource.getAvailableBiometrics();
  if (available.isEmpty) return false;

 
  final token = await SharedPrefs.getToken();
  return token != null && token.isNotEmpty;
}

  @override
  Future<bool> authenticate() async {
    return await localDataSource.authenticate();
  }
}