import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';

class FinancialRemoteDataSource {
  final DioConsumer api;

  FinancialRemoteDataSource({required this.api});

  /// GET financial-summary?patientId=&status=
  /// Omit [patientId] for FAMILY scope; omit [status] for all invoices.
  Future<Map<String, dynamic>> getFinancialSummary({
    String? patientId,
    String? status,
  }) async {
    final query = <String, dynamic>{};
    if (patientId != null && patientId.isNotEmpty) {
      query['patientId'] = patientId;
    }
    if (status != null && status.isNotEmpty) {
      query['status'] = status;
    }

    final response = await api.get(
      EndPoints.financialSummary,
      queryParameters: query.isEmpty ? null : query,
    );
    return _extractMap(response);
  }

  /// GET invoices/:id
  Future<Map<String, dynamic>> getInvoiceById({required String id}) async {
    final response = await api.get(EndPoints.invoiceById(id));
    return _extractMap(response);
  }

  Map<String, dynamic> _extractMap(dynamic response) {
    if (response is! Map) return {};
    final data = Map<String, dynamic>.from(response)['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }
}
