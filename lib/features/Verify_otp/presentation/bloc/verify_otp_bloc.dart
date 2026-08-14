import 'package:bloc/bloc.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/features/Verify_otp/domain/repositories/verify_otp_repository_impl.dart';
import 'package:dental_app/features/Verify_otp/presentation/pages/otp_flow.dart';
import 'package:dental_app/features/biometric_auth/data/datasources/biometric_local_data_source.dart';
import 'package:dio/dio.dart';
import 'package:local_auth/local_auth.dart';
import 'package:meta/meta.dart';
import '../../data/datasources/verify_otp_remote_data_source.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpRepositoryImpl verifyOtpRepository = VerifyOtpRepositoryImpl(
    remoteDataSource: VerifyOtpRemoteDataSource(api: DioConsumer(dio: Dio())),
  );

  VerifyOtpBloc() : super(VerifyOtpInitial()) {
    on<VerifyOtpSubmitted>((event, emit) async {
      emit(VerifyOtpLoading());

      // Change Phone — confirm endpoint
      if (event.flow == OtpFlow.changePhone) {
        final changeResult = await verifyOtpRepository.confirmChangePhone(
          code: event.code,
        );

        await changeResult.fold(
          (failure) async {
            emit(VerifyOtpFailure(
              failureMessage: failure.errMessage,
              errorCode: failure.code,
            ));
          },
          (_) async {
            await SharedPrefs.savePhone(event.phone);

            // Keep biometric secure phone in sync when biometric login is on.
            final biometricLocal = BiometricLocalDataSource(
              localAuth: LocalAuthentication(),
            );
            if (await biometricLocal.isBiometricEnabled()) {
              final existing = await biometricLocal.readCredentials();
              if (existing != null) {
                await biometricLocal.saveCredentials(
                  phone: event.phone,
                  password: existing.password,
                );
              }
            }

            emit(VerifyOtpSuccess(
              activationRequired: false,
              accountStatus: '',
              temporaryToken: null,
            ));
          },
        );
        return;
      }

      // Forgot Password — verify-reset-otp (returns resetToken)
      if (event.flow == OtpFlow.forgotPassword) {
        final resetResult = await verifyOtpRepository.verifyResetOtp(
          phone: event.phone,
          code: event.code,
        );

        resetResult.fold(
          (failure) => emit(VerifyOtpFailure(
            failureMessage: failure.errMessage,
            errorCode: failure.code,
          )),
          (data) {
            // Success with resetToken → continue.
            // Success without resetToken (e.g. already verified) → emit
            // success with null token; UI handles without crashing.
            final rawToken = data['resetToken'];
            final resetToken =
                rawToken is String && rawToken.isNotEmpty ? rawToken : null;

            emit(VerifyOtpSuccess(
              activationRequired: false,
              accountStatus: data['accountStatus']?.toString() ?? '',
              temporaryToken: null,
              resetToken: resetToken,
            ));
          },
        );
        return;
      }

      // Register — existing verifyOtp path unchanged
      final result = await verifyOtpRepository.verifyOtp(
        phone: event.phone,
        code: event.code,
      );

      await result.fold(
        (failure) async {
          emit(VerifyOtpFailure(
            failureMessage: failure.errMessage,
            errorCode: failure.code,
          ));
        },
        (data) async {
          final activationRequired = data['activationRequired'] == true;
          final accountStatus = data['accountStatus'] as String? ?? '';
          final accessToken = data['accessToken'] as String?;
          final refreshToken = data['refreshToken'] as String?;

          if (!activationRequired) {
            if (accessToken != null) await SharedPrefs.saveToken(accessToken);
            if (refreshToken != null) {
              await SharedPrefs.saveRefreshToken(refreshToken);
            }
            if (accountStatus.isNotEmpty) {
              await SharedPrefs.saveAccountStatus(accountStatus);
            }
          }

          emit(VerifyOtpSuccess(
            activationRequired: activationRequired,
            accountStatus: accountStatus,
            temporaryToken: activationRequired
                ? (data['temporaryToken'] as String? ?? accessToken)
                : null,
          ));
        },
      );
    });
  }
}
