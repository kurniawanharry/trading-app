import 'package:common/error/failure_response.dart';
import 'package:common/use_case/use_case.dart';
import 'package:commons_domain/data/models/markets/response/ticker_model.dart';
import 'package:commons_domain/domain/repository/market_repository.dart';
import 'package:dependencies/dartz/dartz.dart';

class StreamMarketUsecase extends UseCaseStream<TickerData, String> {
  final MarketRepository marketRepository;

  StreamMarketUsecase(this.marketRepository);

  @override
  Stream<Either<FailureResponse, TickerData>> call(String params) {
    return marketRepository.streamTradeData(params);
  }
}
