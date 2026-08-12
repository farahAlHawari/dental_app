import 'package:dental_app/core/errors/failure.dart';
import 'package:dental_app/features/appointments/presentation/utils/appointment_error_messages.dart';

extension AppointmentFailureX on Failure {
  String get displayMessage => resolveAppointmentFailure(
        code: code,
        fallback: errMessage,
        statusCode: statusCode,
      );
}
