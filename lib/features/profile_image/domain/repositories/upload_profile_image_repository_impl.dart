import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/profile_image/data/datasources/upload_profile_image_remote_data_source.dart';
import 'package:dental_app/features/profile_image/domain/repositories/upload_profile_image_repository.dart';

class UploadProfileImageRepositoryImpl extends UploadProfileImageRepository {
  final UploadProfileImageRemoteDataSource remoteDataSource;

  UploadProfileImageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> uploadProfileImage({
    required String patientId,
    required String imagePath,
  }) async {
    try {
      final result = await remoteDataSource.uploadProfileImage(
        patientId: patientId,
        imagePath: imagePath,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(
        Failure(
          errMessage: e.errorModel.errorMessage,
          code: e.errorModel.code,
          statusCode: e.errorModel.statusCode,
        ),
      );
    } catch (e) {
      // ================================
      // NEW CODE START — never crash create/edit on upload parse errors
      // ================================
      return Left(Failure(errMessage: e.toString()));
      // ================================
      // NEW CODE END
      // ================================
    }
  }
}
