import 'package:hi_net/data/network/error_handler/error_handler.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';

extension UserMessages on Failure {
  String get userMessage => switch (this) {
        // Dio-specific errors
        DioLocalError(message: final msg) => msg ?? DEFAULT_ERROR_MESSAGE,
        CustomDioLocalError(error: final dioError) =>
          dioError?.message ?? DEFAULT_ERROR_MESSAGE,

        // Server-side errors
        ServerError(message: final msg) => msg ?? Translation.error_server.tr,
        CustomServerError(error: final apiError) => switch (apiError) {
            _ => apiError?.message ?? DEFAULT_ERROR_MESSAGE,
          },

        // Unexpected errors
        UnexpectedError(message: final msg) => msg ?? DEFAULT_ERROR_MESSAGE,

        // No internet connection
        NoInternetConnection() => Translation.error_no_internet.tr,
        _ => DEFAULT_ERROR_MESSAGE
      };
}

final DEFAULT_ERROR_MESSAGE = Translation.error_generic.tr;
