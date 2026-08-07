// ================================
// NEW CODE START
// ================================

import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/expentions.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/profile/data/datasources/patient_remote_data_source.dart';
import 'package:dental_app/features/profile/domain/repositories/patient_repository.dart';
import 'package:dental_app/features/register/presentation/widgets/form_field_schema.dart';

class PatientRepositoryImpl extends PatientRepository {
  final PatientRemoteDataSource remoteDataSource;
  PatientRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FormFieldSchema>>> getFormSchema() async {
    try {
      final result = await remoteDataSource.getFormSchema();
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createPatient({
    required String fullName,
    required String birthDate,
    required String gender,
    required Map<String, dynamic> formValues,
    List<FormFieldSchema>? schema,
  }) async {
    try {
      final result = await remoteDataSource.createPatient(
        fullName: fullName,
        birthDate: birthDate,
        gender: gender,
        formValues: formValues,
        schema: schema,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (e) {
      // Surface parse errors (e.g. Unexpected patient response) in UI.
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getMyPatients() async {
    try {
      final result = await remoteDataSource.getMyPatients();
      return Right(result);
    } on ServerException catch (e) {
      // ================================
      // MODIFIED — Feature 5: expose statusCode for network vs auth handling
      // ================================
      return Left(
        Failure(
          errMessage: e.errorModel.errorMessage,
          code: e.errorModel.code,
          statusCode: e.errorModel.statusCode,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPatientById(String id) async {
    try {
      final result = await remoteDataSource.getPatientById(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updatePatient({
    required String id,
    required String fullName,
    required String birthDate,
    required String gender,
    required Map<String, dynamic> formValues,
    List<FormFieldSchema>? schema,
  }) async {
    try {
      final result = await remoteDataSource.updatePatient(
        id: id,
        fullName: fullName,
        birthDate: birthDate,
        gender: gender,
        formValues: formValues,
        schema: schema,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }
}

// ================================
// NEW CODE END
// ================================
