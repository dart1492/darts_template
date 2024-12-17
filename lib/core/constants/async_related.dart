import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/web.dart';

import '../index.dart';

/// This class is a wrapper for internet requests. It allows us to intercept
/// errors early and convert them to failures to work with them further on
FutureFailable<T> repoCall<T>({
  Failure Function(Map<String, dynamic>)? errorTransformer,
  required Future<T> Function() request,
}) async {
  try {
    return Right(await request());
  } catch (error, stackTrace) {
    if (error is DioException) {
      // if (error.response?.statusCode == 401) {
      //   return await _handleTokenRefreshRetry(request);
      // }
    }

    final failure = await errorHandler(
      error: error,
      stackTrace: stackTrace,
      logger: sl<Logger>(),
      errorTransformer: errorTransformer,
    );
    return Left(failure);
  }
}

/// Function to convert an error object (maybe map, or smth.) into a specific Failure
Future<Failure> errorHandler({
  required Object error,
  required StackTrace stackTrace,
  required Logger logger,
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
          message =
              error.response?.data['msg'] ?? error.response?.data['error'];
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

/// if there is a clear convention for transforming server errors on the project
Failure defaultFailureTrasformer(Object error) {
  return Failure();
}

/// Request statuses for the internet calls
enum RequestStatus {
  initial,
  loading,
  success,
  error,
}

/// MAY BE MODIFIED T OTHE NEEDS OF AN APP
class Failure {
  String? message;
  int? errorCode;
  Failure({
    this.errorCode,
    this.message,
  });
}

typedef FutureFailable<T> = Future<Either<Failure, T>>;

class Debouncer {
  Timer? _timer;
  Duration debounceTime;
  Debouncer({
    required this.debounceTime,
  });

  void call(Function() callback) {
    _timer?.cancel();
    _timer = Timer(debounceTime, callback);
  }

  void dispose() {
    _timer?.cancel();
  }
}
