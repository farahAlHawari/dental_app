import 'package:bloc/bloc.dart';
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:dental_app/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final _repository = NotificationsRepository(
    remoteDataSource: NotificationsRemoteDataSource(
      api: DioConsumer(dio: Dio()),
    ),
  );

  NotificationsBloc() : super(NotificationsInitial()) {
    on<LoadNotificationsRequested>(_onLoad);
    on<LoadUnreadCountRequested>(_onUnreadCount);
    on<MarkAllNotificationsReadRequested>(_onMarkAllRead);
    on<MarkNotificationReadRequested>(_onMarkOneRead);
  }

  Future<void> _onLoad(
    LoadNotificationsRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsListLoading());
    final result = await _repository.getNotifications(
      isRead: event.isRead,
      page: event.page,
      pageSize: event.pageSize,
    );
    result.fold(
      (failure) => emit(
        NotificationsListFailure(errMessage: failure.errMessage),
      ),
      (data) => emit(NotificationsListSuccess(data: data)),
    );
  }

  Future<void> _onUnreadCount(
    LoadUnreadCountRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _repository.getUnreadCount();
    result.fold(
      (_) {},
      (count) => emit(NotificationsUnreadCountSuccess(count: count)),
    );
  }

  Future<void> _onMarkAllRead(
    MarkAllNotificationsReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _repository.markAllRead();
    result.fold(
      (failure) => emit(
        NotificationsActionFailure(errMessage: failure.errMessage),
      ),
      (count) => emit(MarkAllReadSuccess(count: count)),
    );
  }

  Future<void> _onMarkOneRead(
    MarkNotificationReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _repository.markOneRead(id: event.id);
    result.fold(
      (failure) => emit(
        NotificationsActionFailure(errMessage: failure.errMessage),
      ),
      (data) => emit(
        MarkOneReadSuccess(id: event.id, data: data),
      ),
    );
  }
}
