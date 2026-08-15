import 'package:bloc/bloc.dart';
import 'package:dental_app/core/api/auth_error_messages.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/features/biometric_auth/data/datasources/biometric_local_data_source.dart';
import 'package:dental_app/features/change_passwors/domain/repositories/change_password_reposiory_impl.dart';
import 'package:dio/dio.dart';
import 'package:local_auth/local_auth.dart';
import 'package:meta/meta.dart';
import '../../data/datasources/change_password_data_source.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final _repository = ChangePasswordRepositoryImpl(
    dataSource: ChangePasswordDataSource(api: DioConsumer(dio: Dio())),
  );

  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on<ChangePasswordSubmitted>((event, emit) async {
      emit(ChangePasswordLoading());
      final result = await _repository.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );
      await result.fold(
        (failure) async => emit(
          ChangePasswordFailure(
            errMessage: failure.errMessage,
            isInvalidCredentials: AuthErrorMessages.isInvalidCredentials(
              failure.errMessage,
            ),
          ),
        ),
        (_) async {
          // Keep biometric secure credentials in sync with the new password.
          final biometricLocal = BiometricLocalDataSource(
            localAuth: LocalAuthentication(),
          );
          if (await biometricLocal.isBiometricEnabled()) {
            final phone = await SharedPrefs.getPhone() ??
                (await biometricLocal.readCredentials())?.phone;
            if (phone != null && phone.isNotEmpty) {
              await biometricLocal.saveCredentials(
                phone: phone,
                password: event.newPassword,
              );
            }
          }
          emit(ChangePasswordSuccess());
        },
      );
    });
  }
}
