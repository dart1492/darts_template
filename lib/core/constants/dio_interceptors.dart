import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiInterceptor extends Interceptor {
  Logger logger;
  ApiInterceptor({
    required this.logger,
  });
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // TODO: UNCOMMENT IF AUTH TOKEN IS NEEDED FOR THE REQUESTS
    // final tokenInfo = sl<AuthDatasource>().getToken();
    // if (tokenInfo != null && options.path != "/refresh") {
    //   options.headers['Authorization'] = "Bearer ${tokenInfo.access_token}";
    // }

    // options.headers['Content-Type'] = "application/json";

    logger.i(
      'Request ${options.method}\n uri:${options.baseUrl}${options.path}\n Params: ${options.queryParameters}\n data: ${options.data}',
    );

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // sl<CustomLogger>().i("URI: ${response.realUri}\n ${response.data}");
    super.onResponse(response, handler);
  }

  // TODO: UNCOMMENT IF NEEDS HANDLING ERRORS OR (405 STATUS CODE)
  // @override
  // Future onError(DioException err, ErrorInterceptorHandler handler) async {
  //   // if (err.response?.statusCode == 405) {
  //   //   print("Should refresh token");
  //   //   // If a 401 response is received, refresh the access token
  //   //   await sl<AuthDatasource>().refreshToken();

  //   //   // Repeat the request with the updated header
  //   //   return handler.resolve(await sl<Dio>().fetch(err.requestOptions));
  //   // }
  //   // return handler.next(err);
  // }
}
