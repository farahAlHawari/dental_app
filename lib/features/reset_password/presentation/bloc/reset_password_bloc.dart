import 'package:bloc/bloc.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/features/reset_password/data/datasources/reset_password_remote_data_source.dart';
import 'package:dental_app/features/reset_password/domain/repositories/reset_password_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final _repository = ResetPasswordRepositoryImpl(
    remoteDataSource: ResetPasswordRemoteDataSource(
      api: DioConsumer(dio: Dio()),
    ),
  );

  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>((event, emit) async {
      emit(ResetPasswordLoading());
      final result = await _repository.resetPassword(
        resetToken: event.resetToken,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      );
      result.fold(
        (failure) => emit(ResetPasswordFailure(errMessage: failure.errMessage)),
        (_) => emit(ResetPasswordSuccess()),
      );
    });
  }
}
