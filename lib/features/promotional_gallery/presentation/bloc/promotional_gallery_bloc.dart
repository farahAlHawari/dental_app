import 'package:bloc/bloc.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/features/promotional_gallery/data/datasources/app_content_remote_data_source.dart';
import 'package:dental_app/features/promotional_gallery/data/models/app_content.dart';
import 'package:dental_app/features/promotional_gallery/domain/repositories/app_content_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'promotional_gallery_event.dart';
part 'promotional_gallery_state.dart';

class PromotionalGalleryBloc
    extends Bloc<PromotionalGalleryEvent, PromotionalGalleryState> {
  final _repository = AppContentRepositoryImpl(
    remoteDataSource: AppContentRemoteDataSource(
      api: DioConsumer(dio: Dio()),
    ),
  );

  PromotionalGalleryBloc() : super(PromotionalGalleryInitial()) {
    on<LoadAppContentsRequested>(_onLoadContents);
  }

  Future<void> _onLoadContents(
    LoadAppContentsRequested event,
    Emitter<PromotionalGalleryState> emit,
  ) async {
    emit(AppContentsLoading());
    final result = await _repository.list(
      page: event.page,
      pageSize: event.pageSize,
    );
    result.fold(
      (failure) => emit(AppContentsFailure(errMessage: failure.errMessage)),
      (data) => emit(
        AppContentsSuccess(
          items: data.items,
          total: data.total,
        ),
      ),
    );
  }
}
