import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';

class NotificationsRemoteDataSource {
  NotificationsRemoteDataSource({required this.api});

  final DioConsumer api;

  /// GET notifications?isRead=&page=&pageSize=
  Future<Map<String, dynamic>> getNotifications({
    bool? isRead,
    int page = 1,
    int pageSize = 20,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };
    if (isRead != null) {
      query['isRead'] = isRead;
    }
    final response = await api.get(
      EndPoints.notifications,
      queryParameters: query,
    );
    return _extractMap(response);
  }

  /// GET notifications/unread-count
  Future<int> getUnreadCount() async {
    final response = await api.get(EndPoints.notificationsUnreadCount);
    final data = _extractMap(response);
    final count = data['count'];
    if (count is int) return count;
    return int.tryParse('$count') ?? 0;
  }

  /// PATCH notifications/read-all
  Future<int> markAllRead() async {
    final response = await api.patch(EndPoints.notificationsReadAll);
    final data = _extractMap(response);
    final count = data['count'];
    if (count is int) return count;
    return int.tryParse('$count') ?? 0;
  }

  /// PATCH notifications/:id/read
  Future<Map<String, dynamic>> markOneRead({required String id}) async {
    final response = await api.patch(EndPoints.notificationRead(id));
    return _extractMap(response);
  }

  Map<String, dynamic> _extractMap(dynamic response) {
    if (response is! Map) return {};
    final data = Map<String, dynamic>.from(response)['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }
}
