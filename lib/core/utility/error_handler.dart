//usefull classes and functinos for the error handling
import 'package:darts_template_right/core/index.dart';
import 'package:dio/dio.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
/// General failure class, that represents Error,
///  that was received through the interaction with Network in any way
///
/// MAY BE MODIFIED T OTHE NEEDS OF AN APP
class Failure {
  String? message;
  int? errorCode;
  Failure({
    this.errorCode,
    this.message,
  });
}

/// Function to convert an error object (maybe map, or smth.) into a specific Failure
Future<Failure> errorHandler({
  required Object error,
  required StackTrace stackTrace,
  required CustomLogger logger,
  Failure Function(Map<String, dynamic>)? errorTransformer,
}) async {
  try {
    if (error is DioException) {
      String? data = error.response?.data.toString();
      final message = error.response?.statusMessage;
      final code = error.response?.statusCode;
      final stackTrace = error.stackTrace;

      logger.e(
        "Error: $error\n Code: $code\nData:${data.toString()}\n Message:$message\n Trace: ----------------\n${stackTrace.toString().substring(0, 400)}",
      );

      if (error.response != null) {
        final String? message;

        try {
          message = error.response?.data['msg'];
        } finally {}
        return Failure(
          errorCode: error.response?.statusCode,
          message: message,
        );
      }
    } else {
      logger.e(
        "Not DIO error!\n Type:${error.runtimeType}\n Message:$error\n Trace: ----------------\n$stackTrace",
      );
    }

    return defaultFailureTrasformer(error);
  } catch (err) {
    logger.e(err.toString());

    return Failure();
  }
}

/// if there is a clear convention for transforming server errors on thew project
Failure defaultFailureTrasformer(Object error) {
  return Failure();
}
