import 'package:dental_app/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Helpers for financial-summary / invoice payloads.
class FinancialHelper {
  FinancialHelper._();

  static const statusPaid = 'PAID';
  static const statusPartiallyPaid = 'PARTIALLY_PAID';
  static const statusUnpaid = 'UNPAID';

  static double parseAmount(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static String formatAmount(dynamic value) {
    final n = parseAmount(value);
    if (n == n.roundToDouble()) return n.toStringAsFixed(0);
    return n.toStringAsFixed(2);
  }

  static String formatIssuedDate(String? iso) {
    if (iso == null || iso.trim().isEmpty) return '-';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    final local = dt.toLocal();
    return DateFormat.yMMMd().format(local);
  }

  static String statusLabel(String? status) {
    switch ((status ?? '').toUpperCase()) {
      case statusPaid:
        return 'Fully Paid'.tr();
      case statusPartiallyPaid:
        return 'Partially Paid'.tr();
      case statusUnpaid:
        return 'Unpaid'.tr();
      default:
        return (status ?? '-').tr();
    }
  }

  /// Solid accent for status badge / amount value.
  static Color statusColor(BuildContext context, String? status) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    switch ((status ?? '').toUpperCase()) {
      case statusPaid:
        return dark ? AppColors.invoicePaidDark : AppColors.invoicePaidLight;
      case statusPartiallyPaid:
        return dark
            ? AppColors.invoicePartialDark
            : AppColors.invoicePartialLight;
      default:
        return dark
            ? AppColors.invoiceUnpaidDark
            : AppColors.invoiceUnpaidLight;
    }
  }

  static Color statusSoftBg(BuildContext context, String? status) {
    return statusColor(context, status).withOpacity(0.14);
  }

  /// Flatten patients[].invoices and attach patient display fields.
  static List<Map<String, dynamic>> flattenInvoices(
    Map<String, dynamic> summary,
  ) {
    final patients = summary['patients'];
    if (patients is! List) return [];

    final out = <Map<String, dynamic>>[];
    for (final p in patients) {
      if (p is! Map) continue;
      final patient = Map<String, dynamic>.from(p);
      final patientId = patient['patientId'] ?? patient['id'];
      final fullName = (patient['fullName'] ?? '').toString();
      final invoices = patient['invoices'];
      if (invoices is! List) continue;
      for (final inv in invoices) {
        if (inv is! Map) continue;
        final map = Map<String, dynamic>.from(inv);
        map['_patientId'] = patientId;
        map['_patientName'] = fullName;
        map['_patient'] = patient;
        out.add(map);
      }
    }
    return out;
  }

  static String planPlaceholder() => 'Treatment plan'.tr();

  /// API field `treatmentPlanName` on summary + invoice detail payloads.
  static String treatmentPlanName(Map<String, dynamic> invoice) {
    final name = (invoice['treatmentPlanName'] ?? '').toString().trim();
    if (name.isNotEmpty) return name;
    return planPlaceholder();
  }
}
