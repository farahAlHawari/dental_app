import 'package:dio/dio.dart';
import 'package:dental_app/core/api/end_points.dart';

class ForgetPasswordRemoteDataSource {
  Dio dio = Dio();

  Future<bool> forgetPassword({required String phone}) async {
    try {
      final response = await dio.post(
        '${EndPoints.baserUrl}${EndPoints.forgotPassword}',
        data: {"phone": phone},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }
}