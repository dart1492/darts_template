import 'package:darts_template_right/core/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> createLocator() async {
  sl.registerSingleton<CustomLogger>(CustomLogger());

  _registerDio();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
}

void _registerDio() {
  const timeout = Duration(seconds: 30);
  final dioInstance = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
      receiveTimeout: timeout,
      sendTimeout: timeout,
      connectTimeout: timeout,
    ),
  );

  dioInstance.interceptors.add(ApiInterceptor(logger: sl()));
  sl.registerSingleton<Dio>(dioInstance);
}
