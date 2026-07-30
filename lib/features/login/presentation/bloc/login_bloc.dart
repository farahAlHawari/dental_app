import 'package:bloc/bloc.dart';
import 'package:dental_app/features/login/domain/repositories/login_repository_impl.dart';
import 'package:dio/dio.dart';
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
     // بعد
await result.fold(
  (failure) async => emit(LoginFailure(errMessage: failure.errMessage)),
  (data) async {
    final accessToken = data['accessToken'] as String?;
    final refreshToken = data['refreshToken'] as String?;
    final activationRequired = data['activationRequired'] == true;

    if (accessToken != null) await SharedPrefs.saveToken(accessToken);
    if (refreshToken != null) await SharedPrefs.saveRefreshToken(refreshToken);

    if (activationRequired) {
      emit(LoginRequiresPasswordChange(
        temporaryToken: data['temporaryToken'] as String? ?? accessToken ?? '',
      ));
    } else {
      emit(LoginSuccess());
    }
  },
);
    });
  }
}