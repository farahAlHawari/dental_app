// logout_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:dental_app/features/logout/data/datasources/logout_data_source.dart';
import 'package:dental_app/features/logout/domain/repositories/logout_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:dental_app/core/api/dio_consumer.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutRepositoryImpl logoutRepository = LogoutRepositoryImpl(
    remoteDataSource: LogoutRemoteDataSource(api: DioConsumer(dio: Dio())),
  );

  LogoutBloc() : super(LogoutInitial()) {
    on<LogoutRequested>((event, emit) async {
      emit(LogoutLoading());
      final result = await logoutRepository.logout();
      result.fold(
        (failure) => emit(LogoutFailure(errMessage: failure.errMessage)),
        (_) => emit(LogoutSuccess()),
      );
    });
  }
}