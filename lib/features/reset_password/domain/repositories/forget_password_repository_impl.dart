import 'package:dental_app/features/reset_password/data/datasources/forget_password_remote_data_source.dart';
import 'package:dental_app/features/reset_password/domain/repositories/forget_password_repository.dart';

class ForgetPasswordRepositoryImpl extends ForgetPasswordRepository {
  final ForgetPasswordRemoteDataSource remoteDataSource;
  ForgetPasswordRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> forgetPassword({required String phone}) {
    return remoteDataSource.forgetPassword(phone: phone);
  }
}