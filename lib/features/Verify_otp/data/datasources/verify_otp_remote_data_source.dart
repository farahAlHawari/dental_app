// import 'package:dio/dio.dart';
// import 'package:dental_app/core/api/end_points.dart';

// class VerifyOtpRemoteDataSource {
//   Dio dio = Dio();

//   Future<bool> verifyOtp({required String phone, required String code}) async {
//     try {
//       final response = await dio.post(
//         '${EndPoints.baserUrl}${EndPoints.verifyOtp}',
//         data: {"phone": phone, "code": code},
//       );
//       return response.statusCode == 200 || response.statusCode == 201;
//     } catch (e) {
//     if (e is DioException) {
//       print("STATUS: ${e.response?.statusCode}");
//       print("BODY SENT: ${e.requestOptions.data}");
//       print("SERVER SAID: ${e.response?.data}");
//     }
//     return false;
//   }
//   }
// }
// بعد
import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';

class VerifyOtpRemoteDataSource {
  final DioConsumer api;
  VerifyOtpRemoteDataSource({required this.api});

  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    final response = await api.post(
      EndPoints.verifyOtp,
      data: {"phone": phone, "code": code},
    );
    return (response as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }

  // ================================
  // NEW CODE START — Change Phone only
  // ================================
  Future<Map<String, dynamic>> confirmChangePhone({
    required String code,
  }) async {
    final response = await api.post(
      EndPoints.changePhoneConfirm,
      data: {"code": code},
    );
    final map = response as Map<String, dynamic>;
    final data = map['data'];
    if (data is Map<String, dynamic>) return data;
    return <String, dynamic>{};
  }
  // ================================
  // NEW CODE END
  // ================================

  Future<Map<String, dynamic>> verifyResetOtp({
    required String phone,
    required String code,
  }) async {
    final response = await api.post(
      EndPoints.verifyResetOtp,
      data: {"phone": phone, "code": code},
    );
    final map = response as Map<String, dynamic>;
    final data = map['data'];
    if (data is Map<String, dynamic>) return data;
    return map;
  }
}