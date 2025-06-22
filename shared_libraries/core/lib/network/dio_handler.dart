import 'package:dependencies/dio/dio.dart';
import 'package:dependencies/shared_preferences/shared_preferences.dart';

import 'api_interceptors.dart';

class DioHandler {
  final String apiBaseUrl;
  late SharedPreferences sharedPreferences;

  DioHandler(
    this.sharedPreferences, {
    required this.apiBaseUrl,
  });

  Dio get dio => _getDio();

  Dio _getDio() {
    BaseOptions options = BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: 50000,
      receiveTimeout: 30000,
    );
    final dio = Dio(options);
    dio.interceptors.add(ApiInterceptors(sharedPreferences: sharedPreferences));
    return dio;
  }
}
