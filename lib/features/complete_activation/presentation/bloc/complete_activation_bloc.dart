import 'package:bloc/bloc.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/features/complete_activation/data/datasources/complete_activation_remote_data_source.dart';
import 'package:dental_app/features/complete_activation/domain/repositories/complete_activation_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'complete_activation_event.dart';
part 'complete_activation_state.dart';

class CompleteActivationBloc
    extends Bloc<CompleteActivationEvent, CompleteActivationState> {
  final _repository = CompleteActivationRepositoryImpl(
    remoteDataSource: CompleteActivationRemoteDataSource(
      api: DioConsumer(dio: Dio()),
    ),
  );

  CompleteActivationBloc() : super(CompleteActivationInitial()) {
    on<CompleteActivationSubmitted>((event, emit) async {
      emit(CompleteActivationLoading());

      final result = await _repository.completeActivation(
        temporaryToken: event.temporaryToken,
        newPassword: event.newPassword,
      );

      await result.fold(
        (failure) async {
          emit(CompleteActivationFailure(errMessage: failure.errMessage));
        },
        (data) async {
          final accessToken = data['accessToken'] as String?;
          final refreshToken = data['refreshToken'] as String?;
          final accountStatus = data['accountStatus'] as String?;

          if (accessToken != null) await SharedPrefs.saveToken(accessToken);
          if (refreshToken != null) {
            await SharedPrefs.saveRefreshToken(refreshToken);
          }
          if (accountStatus != null && accountStatus.isNotEmpty) {
            await SharedPrefs.saveAccountStatus(accountStatus);
          }

          emit(CompleteActivationSuccess());
        },
      );
    });
  }
}
