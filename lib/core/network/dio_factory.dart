import 'package:dio/dio.dart';
import 'package:startup_launch/core/network/interceptors/auth_interceptor.dart';
import 'package:startup_launch/core/network/interceptors/connectivity_interceptor.dart';
import 'package:startup_launch/core/network/interceptors/logger_interceptor.dart';

class DioFactory {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.mangadex.org',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(ConnectivityInterceptor());
    dio.interceptors.add(AuthInterceptor(dio));
    dio.interceptors.add(loggerInterceptor());

    return dio;
  }
}
