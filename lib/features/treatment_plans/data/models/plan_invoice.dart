import 'package:dental_app/features/treatment_plans/data/models/invoice_status.dart';

class PlanInvoicePayment {
  final String id;
  final String amount;
  final String method;
  final DateTime? paidAt;
  final String? notes;

  const PlanInvoicePayment({
    required this.id,
    required this.amount,
    required this.method,
    this.paidAt,
    this.notes,
  });

  factory PlanInvoicePayment.fromJson(Map<String, dynamic> json) {
    return PlanInvoicePayment(
      id: '${json['id']}',
      amount: json['amount']?.toString() ?? '0',
      method: json['method']?.toString().toUpperCase() ?? 'CASH',
      paidAt: DateTime.tryParse(json['paidAt']?.toString() ?? '')?.toLocal(),
      notes: json['notes']?.toString().trim().isNotEmpty == true
          ? json['notes'].toString().trim()
          : null,
    );
  }

  String get methodLabelKey => method == 'CASH' ? 'Cash' : method;
}

class PlanInvoiceItem {
  final String id;
  final String? description;
  final String quantity;
  final String unitPrice;
  final String totalAmount;

  const PlanInvoiceItem({
    required this.id,
    this.description,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
  });

  factory PlanInvoiceItem.fromJson(Map<String, dynamic> json) {
    final description = json['description']?.toString().trim();
    return PlanInvoiceItem(
      id: '${json['id']}',
      description:
          (description == null || description.isEmpty) ? null : description,
      quantity: json['quantity']?.toString() ?? '0',
      unitPrice: json['unitPrice']?.toString() ?? '0',
      totalAmount: json['totalAmount']?.toString() ?? '0',
    );
  }
}

class PlanInvoiceSummary {
  final String totalBilled;
  final String totalPaid;
  final String totalRemaining;

  const PlanInvoiceSummary({
    required this.totalBilled,
    required this.totalPaid,
    required this.totalRemaining,
  });

  factory PlanInvoiceSummary.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const PlanInvoiceSummary(
        totalBilled: '0.00',
        totalPaid: '0.00',
        totalRemaining: '0.00',
      );
    }
    return PlanInvoiceSummary(
      totalBilled: json['totalBilled']?.toString() ?? '0.00',
      totalPaid: json['totalPaid']?.toString() ?? '0.00',
      totalRemaining: json['totalRemaining']?.toString() ?? '0.00',
    );
  }

  static const empty = PlanInvoiceSummary(
    totalBilled: '0.00',
    totalPaid: '0.00',
    totalRemaining: '0.00',
  );

  double get remainingValue =>
      double.tryParse(totalRemaining.replaceAll(',', '')) ?? 0;

  bool get hasRemaining => remainingValue > 0.0001;
}

class PlanInvoice {
  final String id;
  final String invoiceNumber;
  final InvoiceStatus status;
  final String totalAmount;
  final String paidAmount;
  final String remainingAmount;
  final DateTime? issuedAt;
  final List<PlanInvoicePayment> payments;

  const PlanInvoice({
    required this.id,
    required this.invoiceNumber,
    required this.status,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    this.issuedAt,
    this.payments = const [],
  });

  factory PlanInvoice.fromJson(Map<String, dynamic> json) {
    return PlanInvoice(
      id: '${json['id']}',
      invoiceNumber: json['invoiceNumber']?.toString() ?? '',
      status: InvoiceStatus.fromApiValue(json['status']?.toString()),
      totalAmount: json['totalAmount']?.toString() ?? '0.00',
      paidAmount: json['paidAmount']?.toString() ?? '0.00',
      remainingAmount: json['remainingAmount']?.toString() ?? '0.00',
      issuedAt: DateTime.tryParse(json['issuedAt']?.toString() ?? '')?.toLocal(),
      payments: _parsePayments(json['payments']),
    );
  }

  static List<PlanInvoicePayment> _parsePayments(dynamic raw) {
    if (raw is! List) return const [];
    final items = <PlanInvoicePayment>[];
    for (final item in raw) {
      if (item is Map<String, dynamic>) {
        items.add(PlanInvoicePayment.fromJson(item));
      } else if (item is Map) {
        items.add(PlanInvoicePayment.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return items;
  }
}

class PlanInvoiceDetail extends PlanInvoice {
  final List<PlanInvoiceItem> items;

  const PlanInvoiceDetail({
    required super.id,
    required super.invoiceNumber,
    required super.status,
    required super.totalAmount,
    required super.paidAmount,
    required super.remainingAmount,
    super.issuedAt,
    super.payments,
    this.items = const [],
  });

  factory PlanInvoiceDetail.fromJson(Map<String, dynamic> json) {
    final base = PlanInvoice.fromJson(json);
    return PlanInvoiceDetail(
      id: base.id,
      invoiceNumber: base.invoiceNumber,
      status: base.status,
      totalAmount: base.totalAmount,
      paidAmount: base.paidAmount,
      remainingAmount: base.remainingAmount,
      issuedAt: base.issuedAt,
      payments: base.payments,
      items: _parseItems(json['items']),
    );
  }

  static List<PlanInvoiceItem> _parseItems(dynamic raw) {
    if (raw is! List) return const [];
    final items = <PlanInvoiceItem>[];
    for (final item in raw) {
      if (item is Map<String, dynamic>) {
        items.add(PlanInvoiceItem.fromJson(item));
      } else if (item is Map) {
        items.add(PlanInvoiceItem.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return items;
  }
}

class PlanInvoiceListResult {
  final List<PlanInvoice> items;
  final int total;
  final PlanInvoiceSummary summary;

  const PlanInvoiceListResult({
    required this.items,
    required this.total,
    required this.summary,
  });

  factory PlanInvoiceListResult.fromJson(Map<String, dynamic> json) {
    final raw = json['items'];
    final items = <PlanInvoice>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map<String, dynamic>) {
          items.add(PlanInvoice.fromJson(item));
        } else if (item is Map) {
          items.add(PlanInvoice.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    final totalRaw = json['total'];
    return PlanInvoiceListResult(
      items: items,
      total: totalRaw is int ? totalRaw : int.tryParse('$totalRaw') ?? items.length,
      summary: PlanInvoiceSummary.fromJson(
        json['summary'] is Map
            ? Map<String, dynamic>.from(json['summary'] as Map)
            : null,
      ),
    );
  }
}

String planMoney(String amount) {
  final cleaned = amount.replaceAll(',', '').trim();
  final value = double.tryParse(cleaned);
  if (value == null) return '$amount S.P';

  final negative = value < 0;
  final abs = value.abs();
  final whole = abs.truncate();
  final fraction = abs - whole;
  final digits = whole.toString();
  final grouped = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    if (i > 0 && remaining % 3 == 0) grouped.write(',');
    grouped.write(digits[i]);
  }

  var formatted = grouped.toString();
  if (fraction >= 0.005) {
    final decimals = fraction.toStringAsFixed(2).substring(2).replaceFirst(
          RegExp(r'0+$'),
          '',
        );
    if (decimals.isNotEmpty) formatted = '$formatted.$decimals';
  }
  if (negative) formatted = '-$formatted';
  return '$formatted S.P';
}
