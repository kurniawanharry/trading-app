import 'package:common/error/failure_response.dart';
import 'package:commons_domain/data/models/markets/enum/markets_enum.dart';
import 'package:commons_domain/data/models/markets/response/trade_model.dart';
import 'package:dependencies/dartz/dartz.dart';

abstract class MarketRepository {
  const MarketRepository();
  Stream<Either<FailureResponse, Trade>> streamTradeData(String symbol);
  Stream<Either<FailureResponse, Trade>> streamTradeMultipleData(List<String> symbols);
  Stream<ConnectionStatus> getConnectionStatus();
  void disconnect();
  void reconnect();
}
