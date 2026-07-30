import 'package:bloc/bloc.dart';
import 'package:dental_app/features/reset_password/domain/repositories/forget_password_repository_impl.dart';
import 'package:meta/meta.dart';
import '../../data/datasources/forget_password_remote_data_source.dart';

part 'forget_password_event.dart';
part 'forget_password_state.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final ForgetPasswordRepositoryImpl _repository = ForgetPasswordRepositoryImpl(
    remoteDataSource: ForgetPasswordRemoteDataSource(),
  );

  ForgetPasswordBloc() : super(ForgetPasswordInitial()) {
    on<ForgetPasswordSubmitted>((event, emit) async {
      emit(ForgetPasswordLoading());
      bool isSent = await _repository.forgetPassword(phone: event.phone);
      if (isSent) {
        emit(ForgetPasswordSuccess(phone: event.phone));
      } else {
        emit(ForgetPasswordFailure(failureMessage: 'unenabled to send verification code'));
      }
    });
  }
}