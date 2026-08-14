import 'package:dartz/dartz.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/features/biometric_auth/data/datasources/biometric_local_data_source.dart';
import 'package:dental_app/features/biometric_auth/data/datasources/biometric_remote_data_source.dart';
import 'package:dental_app/features/login/data/datasources/login_data_source.dart';
import 'package:dio/dio.dart';

import 'biometric_repository.dart';

class BiometricRepositoryImpl extends BiometricRepository {
  BiometricRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    LoginDataSource? loginDataSource,
  }) : loginDataSource =
            loginDataSource ?? LoginDataSource(api: DioConsumer(dio: Dio()));

  final BiometricRemoteDataSource remoteDataSource;
  final BiometricLocalDataSource localDataSource;
  final LoginDataSource loginDataSource;

  @override
  Future<Either<Failure, bool>> setBiometricEnabled(
    bool enabled, {
    String? phone,
    String? password,
  }) async {
    try {
      final result =
          await remoteDataSource.setBiometricStatus(enabled: enabled);
      final success = result['success'] == true;

      if (success) {
        await localDataSource.saveBiometricEnabled(enabled);
        if (enabled) {
          final p = phone?.trim() ?? '';
          final pw = password ?? '';
          if (p.isNotEmpty && pw.isNotEmpty) {
            await localDataSource.saveCredentials(phone: p, password: pw);
          }
        } else {
          await localDataSource.clearCredentials();
        }
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
      await SharedPrefs.clearTokens();
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
    return available.isNotEmpty;
  }

  @override
  Future<bool> authenticate() async {
    return localDataSource.authenticate();
  }

  @override
  Future<Either<Failure, void>> loginWithBiometrics() async {
    final biometricOk = await localDataSource.authenticate();
    if (!biometricOk) {
      return Left(
        Failure(
          errMessage:
              'Authentication failed, please try again or use your password',
        ),
      );
    }

    final creds = await localDataSource.readCredentials();
    if (creds == null) {
      return Left(
        Failure(
          errMessage:
              'Sign in with your password once to finish biometric setup',
        ),
      );
    }

    try {
      final data = await loginDataSource.login(
        phone: creds.phone,
        password: creds.password,
      );

      if (data['activationRequired'] == true || data['otpRequired'] == true) {
        return Left(
          Failure(
            errMessage:
                'Authentication failed, please try again or use your password',
          ),
        );
      }

      final accessToken = data['accessToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;
      final accountStatus = data['accountStatus'] as String?;

      if (accessToken == null || accessToken.isEmpty) {
        return Left(
          Failure(
            errMessage:
                'Authentication failed, please try again or use your password',
          ),
        );
      }

      await SharedPrefs.saveToken(accessToken);
      if (refreshToken != null) {
        await SharedPrefs.saveRefreshToken(refreshToken);
      }
      if (accountStatus != null && accountStatus.isNotEmpty) {
        await SharedPrefs.saveAccountStatus(accountStatus);
      }
      await SharedPrefs.savePhone(creds.phone);
      await localDataSource.saveCredentials(
        phone: creds.phone,
        password: creds.password,
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (_) {
      return Left(
        Failure(
          errMessage:
              'Authentication failed, please try again or use your password',
        ),
      );
    }
  }
}
