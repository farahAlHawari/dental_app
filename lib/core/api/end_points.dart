class EndPoints {
//   static const String baserUrl =
//       "https://naming-generous-ember.ngrok-free.dev/api/v1/";
  // static const String baserUrl = "http://192.168.1.104:3000/api/v1/";
  static const String baserUrl = "http://10.255.238.11:3000/api/v1/";
  // static const String baserUrl = "http://localhost:3000/api/v1/";
  static const String register = "auth/register";
  static const String verifyOtp = "auth/register/verify";
  static const String forgotPassword = "auth/forgot-password";
  static const String verifyResetOtp = "auth/verify-reset-otp";
  static const String resetPassword = "auth/reset-password";

  static const String logout = "auth/logout";
  static const String login = "auth/login";
  static const String refreshToken = "auth/refresh";
  static const String changePassword = "auth/change-password";
  static const String completeActivation = "auth/complete-activation";
  static const String language = "auth/language";
  // ================================
  // NEW CODE START
  // ================================
  static const String authMe = "auth/me";
  // ================================
  // NEW CODE END
  // ================================

  static const String patientsFormSchema = "patients/form/schema";
  static const String patients = "patients";
  static const String patientsMy = "patients/my";
  static String patientById(String id) => "patients/$id";
  // ================================
  // NEW CODE START
  // ================================
  static String patientProfileImage(String id) => "patients/$id/profile-image";
  // ================================
  // NEW CODE END
  // ================================

  static const String changePhoneStart = "auth/change-phone/start";
  static const String changePhoneConfirm = "auth/change-phone/confirm";

  static const String biometric = "auth/biometric";

  // ================================
  // NEW CODE START — treatment (patient app)
  // ================================
  static String treatmentPatientHome(String patientId) =>
      "treatment/patients/$patientId/home";

  static String treatmentSessions(String patientId) =>
      "treatment/patients/$patientId/treatment-sessions";

  static String treatmentSessionsForBooking(String patientId) =>
      "treatment/patients/$patientId/treatment-sessions/for-booking";

  static String rateTreatmentSession(String patientId, String sessionId) =>
      "treatment/patients/$patientId/treatment-sessions/$sessionId/rate";

  static String treatmentPlans(String patientId) =>
      "treatment/patients/$patientId/treatment-plans";

  static String treatmentPlanById(String patientId, String planId) =>
      "treatment/patients/$patientId/treatment-plans/$planId";

  static String treatmentPlanSessionFiles(String patientId, String planId) =>
      "treatment/patients/$patientId/treatment-plans/$planId/session-files";

  static String medicalArchive(String patientId) =>
      "treatment/patients/$patientId/medical-archive";
  // ================================
  // NEW CODE END
  // ================================

  // ================================
  // NEW CODE START — financial / invoices
  // ================================
  static const String financialSummary = "financial-summary";
  // static String invoiceById(String id) => "invoices/$id";
  // ================================
  // NEW CODE END
  // ================================

  // ================================
  // NEW CODE START — notifications / FCM device tokens
  // ================================
  static const String deviceTokens = "device-tokens";
  static const String notifications = "notifications";
  static const String notificationsUnreadCount = "notifications/unread-count";
  static const String notificationsReadAll = "notifications/read-all";
  static String notificationRead(String id) => "notifications/$id/read";
  // ================================
  // NEW CODE END
  // ================================

  // ================================
  // Appointments — availability (patient app)
  // ================================
  static const String appointmentAvailabilityDays =
      "appointments/availability/days";
  static const String appointmentAvailabilitySlots =
      "appointments/availability/slots";

  static const String appointments = "appointments";
  static const String appointmentsUpcoming = "appointments/upcoming";
  static const String appointmentsCheckIn = "appointments/check-in";

  static String appointmentById(String id) => "appointments/$id";
  static String appointmentReschedule(String id) =>
      "appointments/$id/reschedule";
  static String appointmentCancel(String id) => "appointments/$id/cancel";

  // ================================
  // Financial — patient app (plan invoices)
  // ================================
  static const String invoices = "invoices";
  static String invoiceById(String id) => "invoices/$id";

  static const String chatbotMessage = "chatbot/message";
  static const String chatbotSummarize = "chatbot/summarize";

  // ================================
  // App contents — promotional gallery (patient app)
  // ================================
  static const String appContents = "app/contents";

  /// Public auth endpoints — no Authorization header.
  static const Set<String> publicAuthPaths = {
    login,
    register,
    verifyOtp,
    refreshToken,
    forgotPassword,
    verifyResetOtp,
    resetPassword,
    completeActivation,
  };

  static bool isPublicAuthPath(String path) {
    final normalized = path.startsWith('/') ? path.substring(1) : path;
    return publicAuthPaths.any(
      (p) =>
          normalized == p ||
          normalized.endsWith('/$p') ||
          normalized.endsWith(p),
    );
  }
}
