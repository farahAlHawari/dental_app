import 'package:bloc/bloc.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/features/reset_password/data/datasources/forget_password_remote_data_source.dart';
import 'package:dental_app/features/reset_password/domain/repositories/forget_password_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'forget_password_event.dart';
part 'forget_password_state.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final _repository = ForgetPasswordRepositoryImpl(
    remoteDataSource: ForgetPasswordRemoteDataSource(
      api: DioConsumer(dio: Dio()),
    ),
  );

  ForgetPasswordBloc() : super(ForgetPasswordInitial()) {
    on<ForgetPasswordSubmitted>((event, emit) async {
      emit(ForgetPasswordLoading());
      final result = await _repository.forgetPassword(phone: event.phone);
      result.fold(
        (failure) => emit(
          ForgetPasswordFailure(failureMessage: failure.errMessage),
        ),
        (_) => emit(ForgetPasswordSuccess(phone: event.phone)),
      );
    });
  }
}
