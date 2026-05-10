import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'failure.dart';

Future<Either<Failure, result>> fastHandler<result extends BasicResponse>({
  required Future<result> Function() request,
}) async {
  try {
    var response = await request();
    if (response.success) {
      return Right(response);
    } else {
      return Left(ServerError(message: response.message));
    }
  } catch (e) {
    return Left(e.handle);
  }
}

extension DioErrorTypeFailure on DioErrorType {
  Failure get getFailure {
    return CustomDioLocalError(error: this);
  }
}

extension ApiErrorTypeFailure on ApiErrorType {
  Failure get getFailure {
    return CustomServerError(error: this);
  }
}

extension ResponseStatusFalse on Response {
  Failure get handle => _handleResponseError(
    (this as DioException).response?.statusCode ??
        (this as DioException).response?.data["statusCode"],
    (this as DioException).response?.data["message"],
    (this as DioException).response?.data["error"],
  );
}

extension ErrorHandler on dynamic {
  Failure get handle {
    return switch (this) {
      // Dio Errors
      DioException() => switch ((this as DioException).type) {
        DioExceptionType.cancel => CustomDioLocalError(
          error: DioErrorType.CANCEL,
        ),
        DioExceptionType.connectionError => NoInternetConnection(),
        DioExceptionType.unknown => CustomDioLocalError(
          error: DioErrorType.UNKNOWN,
        ),
        DioExceptionType.connectionTimeout => CustomDioLocalError(
          error: DioErrorType.CONNECTION_TIMEOUT,
        ),
        DioExceptionType.sendTimeout => CustomDioLocalError(
          error: DioErrorType.SEND_TIMEOUT,
        ),
        DioExceptionType.receiveTimeout => CustomDioLocalError(
          error: DioErrorType.RECEIVE_TIMEOUT,
        ),
        DioExceptionType.badCertificate => CustomDioLocalError(
          error: DioErrorType.BAD_CERTIFICATE,
        ),
        DioExceptionType.badResponse => _handleResponseError(
          ((this as DioException).response?.statusCode ??
              (this as DioException).response?.data["status"]),
          (this as DioException)
              .response
              ?.data?["response"]?["details"]?["message"],
          (this as DioException).response?.data["errorType"],
        ),
        _ => DioLocalError(message: (this as DioException).message),
      },
      // FirebaseException() => _handleResponseError(
      //     (this as FirebaseException).code,
      //     (this as FirebaseException).message,
      //     ""
      // ),
      _ => UnexpectedError(message: toString()),
    };
  }
}

String? _extractValidationError(dynamic responseData) {
  if (responseData == null) return null;

  // Handle validation error structure
  if (responseData is Map<String, dynamic> &&
      responseData['errors'] is Map<String, dynamic>) {
    final errors = responseData['errors'] as Map<String, dynamic>;
    // Get the first error message from any field
    for (var fieldErrors in errors.values) {
      if (fieldErrors is List && fieldErrors.isNotEmpty) {
        return fieldErrors.first.toString();
      }
    }
  }

  // Fallback to message or title
  return responseData['message'] ?? responseData['title'];
}

Failure _handleResponseError(dynamic status, String? message, String? error) {
  if (status != null && (message ?? error) != null) {
    final apiError = ApiErrorType.from(status, error ?? "");
    return apiError != null
        ? CustomServerError(error: apiError)
        : ServerError(message: message ?? error);
  } else {
    return ServerError(message: "An unknown error occurred.");
  }
}

enum DioErrorType {
  CANCEL("CANCEL", "Request was cancelled", "CANCEL"),
  CONNECTION_ERROR(
    "CONNECTION_ERROR",
    "Failed to connect to the server",
    "CONNECTION_ERROR",
  ),
  UNKNOWN("UNKNOWN", "An unknown error occurred", "UNKNOWN"),
  CONNECTION_TIMEOUT(
    "CONNECTION_TIMEOUT",
    "Connection to the server timed out",
    "CONNECTION_TIMEOUT",
  ),
  SEND_TIMEOUT(
    "SEND_TIMEOUT",
    "Request timed out while sending",
    "SEND_TIMEOUT",
  ),
  RECEIVE_TIMEOUT(
    "RECEIVE_TIMEOUT",
    "Response timed out while receiving",
    "RECEIVE_TIMEOUT",
  ),
  BAD_CERTIFICATE(
    "BAD_CERTIFICATE",
    "Invalid certificate from the server",
    "BAD_CERTIFICATE",
  ),
  BAD_RESPONSE(
    "BAD_RESPONSE",
    "Invalid or unexpected response from the server",
    "BAD_RESPONSE",
  );

  // Example HTTP errors
  // INTERNAL_SERVER_ERROR(500, "Internal Server Error", "INTERNAL_SERVER_ERROR"),
  // BAD_REQUEST(400, "Bad Request", "BAD_REQUEST"),
  // UNAUTHORIZED(401, "Unauthorized", "UNAUTHORIZED"),
  // FORBIDDEN(403, "Forbidden", "FORBIDDEN"),
  // NOT_FOUND(404, "Not Found", "NOT_FOUND"),
  // TOO_MANY_REQUESTS(429, "Too Many Requests", "TOO_MANY_REQUESTS");

  final dynamic
  status; // `dynamic` to handle both String (Dio errors) and int (HTTP errors)
  final String message;
  final String error;

  const DioErrorType(this.status, this.message, this.error);

  static DioErrorType? from(dynamic status, String error) {
    for (var e in DioErrorType.values) {
      if (e.status == status && e.error.toLowerCase() == error.toLowerCase()) {
        return e;
      }
    }
    return null;
  }
}

enum ApiErrorType {
  UNAUTHORIZED_EXCEPTION(401, "UnauthorizedException");

  final dynamic statusCode;
  final String message;

  const ApiErrorType(this.statusCode, this.message);

  static ApiErrorType? from(dynamic statusCode, String message) {
    for (var e in ApiErrorType.values) {
      if (e.message.toLowerCase() == message.toLowerCase() &&
          e.statusCode == statusCode) {
        return e;
      }
    }
    return null;
  }
}
