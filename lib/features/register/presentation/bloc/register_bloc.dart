import 'package:bloc/bloc.dart';
import 'package:dental_app/features/register/domain/repositories/register_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
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
      result.fold(
        (failure) => emit(RegisterFailure(errMessage: failure.errMessage)),
        (_) => emit(RegisterSuccess(phone: event.phone)),
      );
    });
  }
}