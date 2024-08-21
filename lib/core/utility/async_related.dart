// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:darts_template_right/core/index.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

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
      //TODO: UNCOMMENT IF REFRESH TOKEN IS NEEDED

      // if (error.response?.statusCode == 401) {
      //   return await _handleTokenRefreshRetry(request);
      // }
    }

    final failure = await errorHandler(
      error: error,
      stackTrace: stackTrace,
      logger: sl<CustomLogger>(),
      errorTransformer: errorTransformer,
    );
    return Left(failure);
  }
}

//TODO: UNCOMMENT IF REFRESH TOKEN IS NEEDED

// Future<Either<Failure, T>> _handleTokenRefreshRetry<T>(
//   Future<T> Function() request,
// ) async {
//   sl<CustomLogger>().i("Refreshing access token...");
//   try {
//     await sl<AuthDatasource>().refreshToken();

//     return Right(await request());
//   } catch (error, stackTrace) {
//     final failure = await errorHandler(
//       error: error,
//       stackTrace: stackTrace,
//       logger: sl<CustomLogger>(),
//     );
//     return Left(failure);
//   }
// }

typedef FutureFailable<T> = Future<Either<Failure, T>>;

enum RequestStatus {
  initial,
  loading,
  success,
  error,
}

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
