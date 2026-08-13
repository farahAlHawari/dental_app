import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/api/end_points.dart';
import 'package:dental_app/features/treatment_plans/data/models/invoice_status.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_invoice.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_session_files.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan.dart';
import 'package:dental_app/features/treatment_plans/data/models/treatment_plan_status.dart';

class TreatmentPlanRemoteDataSource {
  final DioConsumer api;

  TreatmentPlanRemoteDataSource({required this.api});

  /// GET treatment/patients/:id/treatment-plans?status=
  Future<List<TreatmentPlan>> list({
    required String patientId,
    TreatmentPlanStatus? status,
  }) async {
    final response = await api.get(
      EndPoints.treatmentPlans(patientId),
      queryParameters: status == null ? null : {'status': status.apiValue},
    );
    return _extractList(response).map(TreatmentPlan.fromJson).toList();
  }

  /// GET treatment/patients/:id/treatment-plans/:planId
  Future<TreatmentPlan> getById({
    required String patientId,
    required String planId,
  }) async {
    final response = await api.get(
      EndPoints.treatmentPlanById(patientId, planId),
    );
    return TreatmentPlan.fromJson(_extractMap(response));
  }

  /// GET treatment/patients/:id/treatment-plans/:planId/session-files?type=
  Future<List<PlanSessionFiles>> listSessionFiles({
    required String patientId,
    required String planId,
    required PlanFileKind kind,
  }) async {
    final response = await api.get(
      EndPoints.treatmentPlanSessionFiles(patientId, planId),
      queryParameters: {'type': kind.apiType},
    );
    return _extractList(response).map(PlanSessionFiles.fromJson).toList();
  }

  /// GET invoices?patientId=&treatmentPlanId=&status=&pageSize=
  Future<PlanInvoiceListResult> listInvoices({
    required String patientId,
    required String planId,
    InvoiceStatus? status,
  }) async {
    final query = <String, dynamic>{
      'patientId': patientId,
      'treatmentPlanId': planId,
      'page': 1,
      'pageSize': 100,
    };
    if (status != null) query['status'] = status.apiValue;

    final response = await api.get(
      EndPoints.invoices,
      queryParameters: query,
    );
    return PlanInvoiceListResult.fromJson(_extractMap(response));
  }

  /// GET invoices/:id
  Future<PlanInvoiceDetail> getInvoiceById({required String invoiceId}) async {
    final response = await api.get(EndPoints.invoiceById(invoiceId));
    return PlanInvoiceDetail.fromJson(_extractMap(response));
  }

  /// POST treatment/patients/:id/treatment-sessions/:sessionId/rate
  Future<Map<String, dynamic>> rateSession({
    required String patientId,
    required String sessionId,
    required int rating,
  }) async {
    final response = await api.post(
      EndPoints.rateTreatmentSession(patientId, sessionId),
      data: {'rating': rating},
    );
    return _extractMap(response);
  }

  Map<String, dynamic> _extractMap(dynamic response) {
    if (response is! Map) return <String, dynamic>{};
    final map = Map<String, dynamic>.from(response);
    final data = map['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return map;
  }

  List<Map<String, dynamic>> _extractList(dynamic response) {
    if (response is! Map) return [];
    final data = Map<String, dynamic>.from(response)['data'];
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return [];
  }
}
