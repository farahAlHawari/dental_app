import 'package:bloc/bloc.dart';
import 'package:dental_app/features/change_passwors/domain/repositories/change_password_reposiory_impl.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
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
      result.fold(
        (failure) => emit(ChangePasswordFailure(errMessage: failure.errMessage)),
        (_) => emit(ChangePasswordSuccess()),
      );
    });
  }
}