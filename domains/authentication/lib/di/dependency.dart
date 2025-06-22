import 'package:authentication/data/datasource/local/authentication_local_data_source.dart';
import 'package:authentication/data/repository/authentication_repository_impl.dart';
import 'package:authentication/domain/repository/authentication_repository.dart';
import 'package:authentication/domain/usecase/cache_token_usecase.dart';
import 'package:authentication/domain/usecase/get_token_usecase.dart';
import 'package:dependencies/get_it/get_it.dart';

class AuthenticationDependency {
  AuthenticationDependency() {
    _registerDataSources();
    _registerRepository();
    _registerUseCases();
  }

  void _registerDataSources() {
    sl.registerLazySingleton<AuthenticationLocalDataSource>(
      () => AuthenticationLocalDataSourceImpl(
        sharedPreferences: sl(),
      ),
    );
  }

  void _registerRepository() =>
      sl.registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImpl(authenticationLocalDataSource: sl()),
      );

  void _registerUseCases() {
    sl.registerLazySingleton<CacheTokenUseCase>(
      () => CacheTokenUseCase(
        authenticationRepository: sl(),
      ),
    );
    sl.registerLazySingleton<GetTokenUseCase>(
      () => GetTokenUseCase(
        authenticationRepository: sl(),
      ),
    );
  }
}
