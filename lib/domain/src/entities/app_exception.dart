part of 'base_model.dart';

abstract class AppException implements Exception {
  final int? code; // HTTP Status
  final String? message;
  final String? errorCode;

  AppException({required this.code, required this.message, this.errorCode});

  @override
  String toString() {
    return "[$code]: $message : $errorCode";
  }
}

class NetworkException extends AppException {
  NetworkException({required super.code, required super.message, super.errorCode});
}

class LocalException extends AppException {
  LocalException({required super.code, required super.message, super.errorCode});
}

class ErrorCode {
  static const code400 = 400;
  static const code401 = 401;
  static const code403 = 403;
  static const code404 = 404;
  static const code500 = 500;
  static const code502 = 502;
  static const code503 = 503;

  // Self defined
  static const code9999 = 9999;
  static const String unknownNetworkServiceError = 'unknown_network_service_error';
  static const String unknownLocalServiceError = 'unknown_local_service_error';
}
