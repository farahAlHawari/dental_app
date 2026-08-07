import 'package:bloc/bloc.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/features/profile_image/data/datasources/upload_profile_image_remote_data_source.dart';
import 'package:dental_app/features/profile_image/domain/repositories/upload_profile_image_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'upload_profile_image_event.dart';
part 'upload_profile_image_state.dart';

class UploadProfileImageBloc
    extends Bloc<UploadProfileImageEvent, UploadProfileImageState> {
  final _repository = UploadProfileImageRepositoryImpl(
    remoteDataSource: UploadProfileImageRemoteDataSource(
      api: DioConsumer(dio: Dio()),
    ),
  );

  UploadProfileImageBloc() : super(UploadProfileImageInitial()) {
    on<UploadProfileImageRequested>(_onUploadRequested);
  }

  Future<void> _onUploadRequested(
    UploadProfileImageRequested event,
    Emitter<UploadProfileImageState> emit,
  ) async {
    emit(UploadProfileImageLoading());
    final result = await _repository.uploadProfileImage(
      patientId: event.patientId,
      imagePath: event.imagePath,
    );
    result.fold(
      (failure) =>
          emit(UploadProfileImageFailure(errMessage: failure.errMessage)),
      (data) => emit(UploadProfileImageSuccess(patientData: data)),
    );
  }
}
