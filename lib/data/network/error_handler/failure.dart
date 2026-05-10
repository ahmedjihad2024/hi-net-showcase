import 'error_handler.dart';


abstract class Failure {

  const Failure();
}

// *

class DioLocalError extends Failure {
  final String? message;
  DioLocalError({this.message});
}

class CustomDioLocalError extends Failure {
  final DioErrorType? error;
  CustomDioLocalError({this.error});
}

// *

class ServerError extends Failure {
  final String? message;
  ServerError({this.message});
}

class CustomServerError extends Failure {
  final ApiErrorType? error;
  CustomServerError({this.error});
}

// *

class UnexpectedError extends Failure {
  final String? message;
  UnexpectedError({this.message});
}

class NoInternetConnection extends Failure {
  const NoInternetConnection();
}