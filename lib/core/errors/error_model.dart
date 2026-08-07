class ErrorModel {
  final int statusCode;
  final String errorMessage;
  final String? code;

  ErrorModel({
    required this.statusCode,
    required this.errorMessage,
    this.code,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    final rawMessage = json['message'] ?? json['error'] ?? 'Something went wrong';
    String errorMessage;
    if (rawMessage is List) {
      errorMessage = rawMessage.join(', ');
    } else {
      errorMessage = rawMessage.toString();
    }

    final details = json['details'];
    if (details != null &&
        details.toString().isNotEmpty &&
        details.toString() != 'null') {
      errorMessage = '$errorMessage ($details)';
    }

    final rawCode = json['code'] ?? json['errorCode'];
    final code = rawCode?.toString();

    return ErrorModel(
      statusCode: json['statusCode'] is int
          ? json['statusCode'] as int
          : int.tryParse('${json['statusCode']}') ?? 500,
      errorMessage: errorMessage,
      code: (code != null && code.isNotEmpty && code != 'null') ? code : null,
    );
  }
}
