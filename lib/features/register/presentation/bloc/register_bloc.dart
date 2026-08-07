import 'package:bloc/bloc.dart';
import 'package:dental_app/features/register/domain/repositories/register_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import '../../data/datasources/register_remote_data_source.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final _repository = RegisterRepositoryImpl(
    remoteDataSource: RegisterRemoteDataSource(api: DioConsumer(dio: Dio())),
  );

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());
      final result = await _repository.register(
        phone: event.phone,
        password: event.password,
        confirmPassword: event.confirmPassword,
        language: event.language,
      );
      await result.fold(
        (failure) async => emit(
          RegisterFailure(
            errMessage: failure.errMessage,
            statusCode: failure.statusCode,
          ),
        ),
        (_) async {
          // ================================
          // NEW CODE START
          // ================================
          await SharedPrefs.savePhone(event.phone);
          // ================================
          // NEW CODE END
          // ================================
          // Same path as PENDING re-register: go to OTP (register verify).
          emit(RegisterSuccess(phone: event.phone));
        },
      );
    });
  }
}