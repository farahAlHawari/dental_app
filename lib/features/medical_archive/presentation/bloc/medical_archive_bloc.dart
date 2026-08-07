import 'package:bloc/bloc.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/features/medical_archive/data/datasources/medical_archive_remote_data_source.dart';
import 'package:dental_app/features/medical_archive/domain/repositories/medical_archive_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'medical_archive_event.dart';
part 'medical_archive_state.dart';

class MedicalArchiveBloc
    extends Bloc<MedicalArchiveEvent, MedicalArchiveState> {
  final _repository = MedicalArchiveRepositoryImpl(
    remoteDataSource: MedicalArchiveRemoteDataSource(
      api: DioConsumer(dio: Dio()),
    ),
  );

  MedicalArchiveBloc() : super(MedicalArchiveInitial()) {
    on<LoadMedicalArchiveRequested>(_onLoad);
  }

  Future<void> _onLoad(
    LoadMedicalArchiveRequested event,
    Emitter<MedicalArchiveState> emit,
  ) async {
    emit(MedicalArchiveLoading(type: event.type));
    final result = await _repository.getMedicalArchive(
      patientId: event.patientId,
      type: event.type,
    );
    result.fold(
      (failure) => emit(
        MedicalArchiveFailure(
          type: event.type,
          errMessage: failure.errMessage,
        ),
      ),
      (items) => emit(
        MedicalArchiveSuccess(type: event.type, items: items),
      ),
    );
  }
}
