enum TreatmentPlanStatus {
  active,
  completed,
  cancelled;

  static TreatmentPlanStatus fromApiValue(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'COMPLETED':
        return TreatmentPlanStatus.completed;
      case 'CANCELLED':
        return TreatmentPlanStatus.cancelled;
      case 'ACTIVE':
      default:
        return TreatmentPlanStatus.active;
    }
  }

  String get apiValue {
    switch (this) {
      case TreatmentPlanStatus.active:
        return 'ACTIVE';
      case TreatmentPlanStatus.completed:
        return 'COMPLETED';
      case TreatmentPlanStatus.cancelled:
        return 'CANCELLED';
    }
  }

  String get labelKey {
    switch (this) {
      case TreatmentPlanStatus.active:
        return 'In Progress';
      case TreatmentPlanStatus.completed:
        return 'Completed';
      case TreatmentPlanStatus.cancelled:
        return 'Cancelled';
    }
  }
}

