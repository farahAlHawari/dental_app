enum TreatmentSessionStatus {
  pending,
  booked,
  inTreatment,
  completed,
  cancelled;

  static TreatmentSessionStatus fromApiValue(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'BOOKED':
        return TreatmentSessionStatus.booked;
      case 'IN_TREATMENT':
        return TreatmentSessionStatus.inTreatment;
      case 'COMPLETED':
        return TreatmentSessionStatus.completed;
      case 'CANCELLED':
        return TreatmentSessionStatus.cancelled;
      case 'PENDING':
      default:
        return TreatmentSessionStatus.pending;
    }
  }

  String get labelKey {
    switch (this) {
      case TreatmentSessionStatus.pending:
        return 'Waiting';
      case TreatmentSessionStatus.booked:
        return 'Booked';
      case TreatmentSessionStatus.inTreatment:
        return 'In Treatment';
      case TreatmentSessionStatus.completed:
        return 'Completed';
      case TreatmentSessionStatus.cancelled:
        return 'Cancelled';
    }
  }
}
