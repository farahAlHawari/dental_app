import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';
import 'package:dental_app/features/promotional_gallery/data/models/app_content.dart';

class AppContentRemoteDataSource {
  final DioConsumer api;

  AppContentRemoteDataSource({required this.api});

  /// GET app/contents?page=&pageSize=
  Future<AppContentListResult> list({
    int page = 1,
    int pageSize = 50,
  }) async {
    final response = await api.get(
      EndPoints.appContents,
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );
    final data = _extractData(response);
    if (data == null) {
      return const AppContentListResult(items: [], total: 0);
    }

    final itemsRaw = data['items'];
    final items = itemsRaw is List
        ? itemsRaw
            .whereType<Map>()
            .map((e) => AppContent.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <AppContent>[];
    final total = data['total'] is int
        ? data['total'] as int
        : int.tryParse('${data['total']}') ?? items.length;

    return AppContentListResult(items: items, total: total);
  }

  Map<String, dynamic>? _extractData(dynamic response) {
    if (response is! Map) return null;
    final map = Map<String, dynamic>.from(response);
    final data = map['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return map;
  }
}
