// import 'package:bloc/bloc.dart';
// import 'package:bloc/bloc.dart';
// import 'package:dental_app/features/Verify_otp/domain/repositories/verify_otp_repository_impl.dart';
// import 'package:meta/meta.dart';
// import '../../data/datasources/verify_otp_remote_data_source.dart';

// part 'verify_otp_event.dart';
// part 'verify_otp_state.dart';

// class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
//   VerifyOtpRepositoryImpl verifyOtpRepository = VerifyOtpRepositoryImpl(
//     remoteDataSource: VerifyOtpRemoteDataSource(),
//   );

//   VerifyOtpBloc() : super(VerifyOtpInitial()) {
//     on<VerifyOtpSubmitted>((event, emit) async {
//       emit(VerifyOtpLoading());
//       bool isVerified = await verifyOtpRepository.verifyOtp(
//         phone: event.phone,
//         code: event.code,
//       );
//       if (isVerified) {
//         emit(VerifyOtpSuccess());
//       } else {
//         emit(VerifyOtpFailure(failureMessage: 'invalid code, please try again'));
//       }
//     });
//   }
// }
// بعد
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/features/Verify_otp/domain/repositories/verify_otp_repository_impl.dart';
import '../../data/datasources/verify_otp_remote_data_source.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpRepositoryImpl verifyOtpRepository = VerifyOtpRepositoryImpl(
    remoteDataSource: VerifyOtpRemoteDataSource(api: DioConsumer(dio: Dio())),
  );

  VerifyOtpBloc() : super(VerifyOtpInitial()) {
    on<VerifyOtpSubmitted>((event, emit) async {
      emit(VerifyOtpLoading());

      final result = await verifyOtpRepository.verifyOtp(
        phone: event.phone,
        code: event.code,
      );

      await result.fold(
        (failure) async {
          emit(VerifyOtpFailure(failureMessage: failure.errMessage));
        },
        (data) async {
          final activationRequired = data['activationRequired'] == true;
          final accountStatus = data['accountStatus'] as String? ?? '';
          final accessToken = data['accessToken'] as String?;
          final refreshToken = data['refreshToken'] as String?;

          if (!activationRequired) {
            if (accessToken != null) await SharedPrefs.saveToken(accessToken);
            if (refreshToken != null) await SharedPrefs.saveRefreshToken(refreshToken);
          }

          emit(VerifyOtpSuccess(
            activationRequired: activationRequired,
            accountStatus: accountStatus,
            temporaryToken: activationRequired
                ? (data['temporaryToken'] as String? ?? accessToken)
                : null,
          ));
        },
      );
    });
  }
}