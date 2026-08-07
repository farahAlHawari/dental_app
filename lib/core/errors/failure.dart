class Failure {
  final String errMessage;
  final String? code;
  // ================================
  // NEW CODE START
  // ================================
  /// HTTP status when available (0 = no response / network).
  final int? statusCode;
  // ================================
  // NEW CODE END
  // ================================

  Failure({
    required this.errMessage,
    this.code,
    // ================================
    // NEW CODE START
    // ================================
    this.statusCode,
    // ================================
    // NEW CODE END
    // ================================
  });
}
