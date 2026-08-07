// ================================
// NEW CODE START
// ================================

import 'package:dartz/dartz.dart';
import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/register/presentation/widgets/form_field_schema.dart';

abstract class PatientRepository {
  Future<Either<Failure, List<FormFieldSchema>>> getFormSchema();

  Future<Either<Failure, Map<String, dynamic>>> createPatient({
    required String fullName,
    required String birthDate,
    required String gender,
    required Map<String, dynamic> formValues,
    List<FormFieldSchema>? schema,
  });

  Future<Either<Failure, List<Map<String, dynamic>>>> getMyPatients();

  Future<Either<Failure, Map<String, dynamic>>> getPatientById(String id);

  Future<Either<Failure, Map<String, dynamic>>> updatePatient({
    required String id,
    required String fullName,
    required String birthDate,
    required String gender,
    required Map<String, dynamic> formValues,
    List<FormFieldSchema>? schema,
  });
}

// ================================
// NEW CODE END
// ================================
