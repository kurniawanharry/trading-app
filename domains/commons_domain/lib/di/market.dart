import 'package:commons_domain/data/datasource/remote/gecko_remote_datasource.dart';
import 'package:commons_domain/data/repository/gecko_repository_impl.dart';
import 'package:commons_domain/data/repository/market_repository_impl.dart';
import 'package:commons_domain/domain/repository/gecko_repository.dart';
import 'package:commons_domain/domain/repository/market_repository.dart';
import 'package:commons_domain/domain/usecase/market/gecko_usecase.dart';
import 'package:commons_domain/domain/usecase/market/stream_market_multiple_usecase.dart';
import 'package:commons_domain/domain/usecase/market/stream_market_status.dart';
import 'package:commons_domain/domain/usecase/market/stream_market_usecase.dart';
import 'package:dependencies/get_it/get_it.dart';

class MarketDependency {
  MarketDependency() {
    _registerUsecases();
    _registerRepositories();
    _registerDataSources();
  }

  void _registerDataSources() {
    sl.registerLazySingleton<GeckoRemoteDataSource>(() => GeckoRemoteDataSourceImpl(sl()));
  }

  void _registerRepositories() {
    sl.registerLazySingleton<MarketRepository>(() => MarketRepositoryImpl(sl()));
    sl.registerLazySingleton<GeckoRepository>(() => CoinGeckoRepositoryImpl(sl()));
  }

  void _registerUsecases() {
    sl.registerLazySingleton<StreamMarketUsecase>(() => StreamMarketUsecase(sl()));
    sl.registerLazySingleton<StreamMarketMultipleUsecase>(() => StreamMarketMultipleUsecase(sl()));
    sl.registerLazySingleton<StreamMarketStatus>(() => StreamMarketStatus(sl()));
    sl.registerLazySingleton<GeckoUsecase>(() => GeckoUsecase(sl()));
  }
}
