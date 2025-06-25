import 'package:common/error/failure_response.dart';
import 'package:common/use_case/use_case.dart';
import 'package:commons_domain/data/models/markets/response/ticker_model.dart';
import 'package:commons_domain/domain/repository/market_repository.dart';
import 'package:dependencies/dartz/dartz.dart';

class StreamMarketMultipleUsecase extends UseCaseStream<TickerData, List<String>> {
  final MarketRepository marketRepository;

  StreamMarketMultipleUsecase(this.marketRepository);

  @override
  Stream<Either<FailureResponse, TickerData>> call(List<String> params) {
    return marketRepository.streamTradeMultipleData(params);
  }
}
