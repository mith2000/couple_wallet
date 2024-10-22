part of 'base_model.dart';

abstract class AppException implements Exception {
  final int? code; // HTTP Status
  final String? message;
  final String? errorCode;

  AppException({required this.code, required this.message, this.errorCode});

  @override
  String toString() {
    return "[$code]: $errorCode\nMessage: $message";
  }
}

class NetworkException extends AppException {
  NetworkException(
      {required super.code, required super.message, super.errorCode});
}

class LocalException extends AppException {
  LocalException(
      {required super.code, required super.message, super.errorCode});
}

class ErrorCode {
  // Bad request
  static const code400 = 400;

  // Unauthorized
  static const code401 = 401;

  // Forbidden
  static const code403 = 403;

  // Not found
  static const code404 = 404;

  // Conflict
  static const code409 = 409;

  // Internal server error
  static const code500 = 500;

  // Bad gateway
  static const code502 = 502;

  // Service unavailable
  static const code503 = 503;

  // Self defined
  static const code9999 = 9999;
  static const String unknownNetworkServiceError =
      'unknown_network_service_error';
  static const String unknownLocalServiceError = 'unknown_local_service_error';
  static const String lackOfInputError = 'lack_of_input';
  static const String lackOfParticipantsError = 'lack_of_participants';
  static const String notFoundError = 'not_found';
  static const String alreadyExistedError = 'already_existed';
}
