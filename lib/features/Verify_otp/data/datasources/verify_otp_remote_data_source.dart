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
}