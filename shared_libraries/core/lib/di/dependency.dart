import 'package:core/network/dio_handler.dart';
import 'package:core/network/socket_handler.dart';
import 'package:dependencies/dio/dio.dart';
import 'package:dependencies/get_it/get_it.dart';

class RegisterCoreModule {
  final String baseUrl;
  final String socketUrl;

  RegisterCoreModule({
    required this.baseUrl,
    required this.socketUrl,
  }) {
    _registerCore(baseUrl: baseUrl, socketUrl: socketUrl);
  }

  _registerCore({required String baseUrl, required String socketUrl}) {
    sl.registerLazySingleton<Dio>(() => sl<DioHandler>().dio);
    sl.registerLazySingleton<SocketDataSource>(() => SocketHandler(
          sl(),
          socketBaseUrl: socketUrl,
        ));
    sl.registerLazySingleton<DioHandler>(
      () => DioHandler(
        sl(),
        apiBaseUrl: baseUrl,
      ),
    );
  }
}
