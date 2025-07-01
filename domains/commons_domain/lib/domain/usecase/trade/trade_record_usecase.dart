import 'package:common/error/failure_response.dart';
import 'package:common/use_case/use_case.dart';
import 'package:commons_domain/data/models/trades/response/simulated_trade.dart';
import 'package:commons_domain/domain/repository/trade_repository.dart';
import 'package:dependencies/dartz/dartz.dart';

class TradeRecordUsecase extends UseCase<void, SimulatedTrade> {
  TradeRepository tradeRepository;
  TradeRecordUsecase(this.tradeRepository);

  @override
  Future<Either<FailureResponse, void>> call(params) async {
    return tradeRepository.recordTrade(params);
  }
}
