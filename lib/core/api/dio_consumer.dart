// بعد
import 'package:dental_app/core/api/auth_error_messages.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dio/dio.dart';
import '../errors/error_model.dart';
import '../errors/expentions.dart';
import 'end_points.dart';

class _RefreshOutcome {
  const _RefreshOutcome({
    this.accessToken,
    this.rateLimited = false,
    this.sessionInvalid = false,
  });

  final String? accessToken;
  final bool rateLimited;
  final bool sessionInvalid;
}

class DioConsumer {
  final Dio dio;

  static const String _authRetriedExtra = 'authRetried';

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoints.baserUrl;
    dio.options.headers['ngrok-skip-browser-warning'] = 'true';
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
          final status = error.response?.statusCode;
          final path = error.requestOptions.path;
          final message = AuthErrorMessages.messageFromResponseData(
            error.response?.data,
          );
          final alreadyRetried =
              error.requestOptions.extra[_authRetriedExtra] == true;

          // Rate limit — never refresh / retry / clear session.
          if (status == 429) {
            return handler.next(error);
          }

          if (status != 401) {
            return handler.next(error);
          }

          // Wrong phone/password (or wrong current password) — session is alive.
          if (AuthErrorMessages.isInvalidCredentials(message)) {
            return handler.next(error);
          }

          // login / refresh / other public auth: never attempt refresh here.
          if (EndPoints.isPublicAuthPath(path)) {
            return handler.next(error);
          }

          // Already retried once after a successful refresh — stop the loop.
          if (alreadyRetried) {
            if (AuthErrorMessages.isInvalidSession(message)) {
              await SharedPrefs.clearTokens();
            }
            return handler.next(error);
          }

          final refresh = await _refreshAccessToken();

          // Refresh itself hit 429 — user is still logged in; pass original error.
          if (refresh.rateLimited) {
            return handler.next(error);
          }

          if (refresh.accessToken != null) {
            final retryOptions = error.requestOptions;
            retryOptions.headers['Authorization'] =
                'Bearer ${refresh.accessToken}';
            retryOptions.extra[_authRetriedExtra] = true;
            try {
              final retryResponse = await dio.fetch(retryOptions);
              return handler.resolve(retryResponse);
            } on DioException catch (retryError) {
              return handler.next(retryError);
            }
          }

          // clearTokens only when refresh proves the session is dead
          // (no refresh token, or refresh returned 401) — not on network blips.
          if (refresh.sessionInvalid) {
            await SharedPrefs.clearTokens();
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<_RefreshOutcome> _refreshAccessToken() async {
    final refreshToken = await SharedPrefs.getRefreshToken();
    if (refreshToken == null || refreshToken.trim().isEmpty) {
      return const _RefreshOutcome(sessionInvalid: true);
    }

    try {
      // Separate Dio — no interceptors (avoids recursion on auth/refresh).
      final refreshDio = Dio()
        ..options.baseUrl = EndPoints.baserUrl
        ..options.headers['ngrok-skip-browser-warning'] = 'true';
      final response = await refreshDio.post(
        EndPoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final data = response.data['data'] as Map<String, dynamic>?;
      final newAccessToken = data?['accessToken'] as String?;
      final newRefreshToken = data?['refreshToken'] as String?;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        return const _RefreshOutcome(sessionInvalid: true);
      }

      await SharedPrefs.saveToken(newAccessToken);
      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await SharedPrefs.saveRefreshToken(newRefreshToken);
      }

      return _RefreshOutcome(accessToken: newAccessToken);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 429) {
        return const _RefreshOutcome(rateLimited: true);
      }
      if (status == 401) {
        return const _RefreshOutcome(sessionInvalid: true);
      }
      // Network / 5xx — keep tokens; caller passes original error through.
      return const _RefreshOutcome();
    } catch (_) {
      return const _RefreshOutcome();
    }
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
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<dynamic> delete(String path, {dynamic data}) async {
    try {
      final response = await dio.delete(path, data: data);
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
        throw ServerException(errorModel: ErrorModel.fromJson(data));
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
