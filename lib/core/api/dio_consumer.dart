// بعد
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dio/dio.dart';
import '../errors/error_model.dart';
import '../errors/expentions.dart';
import 'end_points.dart';

class DioConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoints.baserUrl;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SharedPrefs.getToken();
          if (token != null && options.path != EndPoints.refreshToken) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final isUnauthorized = error.response?.statusCode == 401;
          final isRefreshCall = error.requestOptions.path == EndPoints.refreshToken;

          if (isUnauthorized && !isRefreshCall) {
            try {
              final newAccessToken = await _refreshAccessToken();
              if (newAccessToken != null) {
                final retryOptions = error.requestOptions;
                retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                final retryResponse = await dio.fetch(retryOptions);
                return handler.resolve(retryResponse);
              }
            } catch (_) {
              // فشل الـ refresh نفسه، منكمل تحت لـ logout
            }
            await SharedPrefs.clearTokens();
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<String?> _refreshAccessToken() async {
    final refreshToken = await SharedPrefs.getRefreshToken();
    if (refreshToken == null) return null;


    final refreshDio = Dio()..options.baseUrl = EndPoints.baserUrl;
    final response = await refreshDio.post(
      EndPoints.refreshToken,
      data: {"refreshToken": refreshToken},
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final newAccessToken = data['accessToken'] as String?;
    final newRefreshToken = data['refreshToken'] as String?;

    if (newAccessToken != null) await SharedPrefs.saveToken(newAccessToken);
    if (newRefreshToken != null) await SharedPrefs.saveRefreshToken(newRefreshToken);

    return newAccessToken;
  }

  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }
Future<dynamic> patch(String path, {dynamic data}) async {
  try {
    final response = await dio.patch(path, data: data);
    return response.data;
  } on DioException catch (e) {
    _handleDioException(e);
  }
}
  void _handleDioException(DioException e) {
    if (e.response != null) {
      throw ServerException(
        errorModel: ErrorModel.fromJson(e.response!.data),
      );
    } else {
      throw ServerException(
        errorModel: ErrorModel(
          statusCode: 0,
          errorMessage: "No Internet Connection",
        ),
      );
    }
  }
}