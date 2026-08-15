import 'package:bloc/bloc.dart';
import 'package:dental_app/features/biometric_auth/data/datasources/biometric_local_data_source.dart';
import 'package:dental_app/features/login/domain/repositories/login_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:local_auth/local_auth.dart';
import 'package:meta/meta.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import '../../data/datasources/login_data_source.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final _repository = LoginRepositoryImpl(
    loginDataSource: LoginDataSource(api: DioConsumer(dio: Dio())),
  );

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      final result = await _repository.login(
        phone: event.phone,
        password: event.password,
      );

      await result.fold(
        (failure) async => emit(LoginFailure(errMessage: failure.errMessage)),
        (data) async {
          final activationRequired = data['activationRequired'] == true;
          final otpRequired = data['otpRequired'] == true;

          // INVITED — Complete Activation (temporaryToken in memory only).
          if (activationRequired) {
            final temporaryToken = data['temporaryToken'] as String? ?? '';
            await SharedPrefs.savePhone(event.phone);
            emit(LoginRequiresPasswordChange(temporaryToken: temporaryToken));
            return;
          }

          // ================================
          // NEW CODE START — PENDING_ACTIVATION: OTP like Register
          // Ignore temporaryToken from this response. Go to Verify OTP.
          // access/refresh are saved AFTER successful OTP verify (VerifyOtpBloc).
          // ================================
          if (otpRequired) {
            await SharedPrefs.savePhone(event.phone);
            emit(LoginRequiresOtp(phone: event.phone));
            return;
          }
          // ================================
          // NEW CODE END
          // ================================

          // Normal ACTIVE login
          final accessToken = data['accessToken'] as String?;
          final refreshToken = data['refreshToken'] as String?;
          final accountStatus = data['accountStatus'] as String?;

          if (accessToken != null) await SharedPrefs.saveToken(accessToken);
          if (refreshToken != null) {
            await SharedPrefs.saveRefreshToken(refreshToken);
          }
          if (accountStatus != null && accountStatus.isNotEmpty) {
            await SharedPrefs.saveAccountStatus(accountStatus);
          }
          await SharedPrefs.savePhone(event.phone);

          // Feature 8: keep secure credentials in sync when biometric is on.
          final biometricLocal = BiometricLocalDataSource(
            localAuth: LocalAuthentication(),
          );
          if (await biometricLocal.isBiometricEnabled()) {
            await biometricLocal.saveCredentials(
              phone: event.phone,
              password: event.password,
            );
          }

          emit(LoginSuccess());
        },
      );
    });
  }
}
