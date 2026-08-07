import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/change_phone_number/data/datasources/change_phone_data_source.dart';
import 'package:dental_app/features/change_phone_number/domain/repositories/change_phone_repository.dart';

class ChangePhoneRepositoryImpl extends ChangePhoneRepository {
  final ChangePhoneDataSource dataSource;
  ChangePhoneRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> startChangePhone({
    required String newPhone,
  }) async {
    try {
      final result = await dataSource.startChangePhone(newPhone: newPhone);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }
}
