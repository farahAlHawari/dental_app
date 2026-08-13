enum InvoiceStatus {
  unpaid,
  partiallyPaid,
  paid,
  voided;

  static InvoiceStatus fromApiValue(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'PARTIALLY_PAID':
        return InvoiceStatus.partiallyPaid;
      case 'PAID':
        return InvoiceStatus.paid;
      case 'VOID':
        return InvoiceStatus.voided;
      case 'UNPAID':
      default:
        return InvoiceStatus.unpaid;
    }
  }

  String get apiValue {
    switch (this) {
      case InvoiceStatus.unpaid:
        return 'UNPAID';
      case InvoiceStatus.partiallyPaid:
        return 'PARTIALLY_PAID';
      case InvoiceStatus.paid:
        return 'PAID';
      case InvoiceStatus.voided:
        return 'VOID';
    }
  }

  String get labelKey {
    switch (this) {
      case InvoiceStatus.unpaid:
        return 'Unpaid';
      case InvoiceStatus.partiallyPaid:
        return 'Partially paid';
      case InvoiceStatus.paid:
        return 'Fully paid';
      case InvoiceStatus.voided:
        return 'Void';
    }
  }
}
