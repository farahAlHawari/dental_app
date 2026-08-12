/// وضع الشات بوت على الباك — TRIAGE للحجز، EDUCATION للأسئلة العامة.
enum ChatbotApiMode {
  triage('TRIAGE'),
  education('EDUCATION');

  final String apiValue;
  const ChatbotApiMode(this.apiValue);

  static const triageMaxTurns = 6;
  static const educationMaxTurns = 12;
}
