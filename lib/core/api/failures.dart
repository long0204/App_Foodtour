class ApiException implements Exception {
  final String errorMessage;
  final int code;

  ApiException(this.errorMessage, {this.code = 400});

  @override
  String toString() => errorMessage;
}