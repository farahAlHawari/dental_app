import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:local_auth/local_auth.dart';
import 'package:meta/meta.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import '../../data/datasources/biometric_remote_data_source.dart';
import '../../data/datasources/biometric_local_data_source.dart';
import '../../domain/repositories/biometric_repository_impl.dart';

part 'biometric_event.dart';
part 'biometric_state.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  final _repository = BiometricRepositoryImpl(
    remoteDataSource: BiometricRemoteDataSource(api: DioConsumer(dio: Dio())),
    localDataSource: BiometricLocalDataSource(localAuth: LocalAuthentication()),
  );

  BiometricBloc() : super(BiometricInitial()) {
    on<ToggleBiometricRequested>(_onToggleRequested);
    on<CheckBiometricAvailabilityRequested>(_onCheckAvailability);
    on<BiometricAuthenticateRequested>(_onAuthenticateRequested);
  }

  Future<void> _onToggleRequested(
    ToggleBiometricRequested event,
    Emitter<BiometricState> emit,
  ) async {
    emit(BiometricToggleLoading());
    final result = await _repository.setBiometricEnabled(
      event.enabled,
      phone: event.phone,
      password: event.password,
    );
    result.fold(
      (failure) => emit(BiometricToggleFailure(errMessage: failure.errMessage)),
      (success) => emit(BiometricToggleSuccess(enabled: event.enabled)),
    );
  }

  Future<void> _onCheckAvailability(
    CheckBiometricAvailabilityRequested event,
    Emitter<BiometricState> emit,
  ) async {
    final available = await _repository.canUseBiometrics();
    emit(BiometricAvailabilityChecked(available: available));
  }

  Future<void> _onAuthenticateRequested(
    BiometricAuthenticateRequested event,
    Emitter<BiometricState> emit,
  ) async {
    emit(BiometricAuthenticating());
    final result = await _repository.loginWithBiometrics();
    await result.fold(
      (failure) async {
        emit(BiometricAuthenticateFailure(errMessage: failure.errMessage));
        // Restore button visibility after failure.
        final available = await _repository.canUseBiometrics();
        emit(BiometricAvailabilityChecked(available: available));
      },
      (_) async {
        emit(BiometricAuthenticateSuccess());
      },
    );
  }
}
