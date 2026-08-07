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
          final isPublic = EndPoints.isPublicAuthPath(options.path);
          if (token != null && !isPublic) {
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            options.headers.remove('Authorization');
          }
          // ================================
          // NEW CODE START
          // ================================
          // FormData must set its own Content-Type (with boundary).
          // Removing a forced/json content-type prevents multipart failures.
          if (options.data is FormData) {
            options.headers.remove(Headers.contentTypeHeader);
          }
          // ================================
          // NEW CODE END
          // ================================
          handler.next(options);
        },
        onError: (error, handler) async {
          final isUnauthorized = error.response?.statusCode == 401;
          final isPublic =
              EndPoints.isPublicAuthPath(error.requestOptions.path);

          // Skip token refresh/clear for public auth endpoints (login, register, …)
          if (isUnauthorized && !isPublic) {
            try {
              final newAccessToken = await _refreshAccessToken();
              if (newAccessToken != null) {
                final retryOptions = error.requestOptions;
                retryOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';
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

  // ================================
  // NEW CODE START
  // ================================
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }
  // ================================
  // NEW CODE END
  // ================================
  void _handleDioException(DioException e) {
    // ================================
    // MODIFIED
    // ================================
    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        throw ServerException(
          errorModel: ErrorModel.fromJson(data),
        );
      }
      if (data is Map) {
        throw ServerException(
          errorModel: ErrorModel.fromJson(Map<String, dynamic>.from(data)),
        );
      }
      throw ServerException(
        errorModel: ErrorModel(
          statusCode: e.response!.statusCode ?? 500,
          errorMessage: data?.toString() ?? 'Something went wrong',
        ),
      );
    } else {
      throw ServerException(
        errorModel: ErrorModel(
          statusCode: 0,
          errorMessage: "No Internet Connection",
        ),
      );
    }
    // ================================
    // MODIFIED END
    // ================================
  }
}