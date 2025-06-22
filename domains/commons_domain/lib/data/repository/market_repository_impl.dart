import 'dart:convert';

import 'package:common/error/failure_response.dart';
import 'package:commons_domain/data/models/markets/enum/markets_enum.dart';
import 'package:commons_domain/data/models/markets/response/trade_model.dart';
import 'package:commons_domain/domain/repository/market_repository.dart';
import 'package:core/network/socket_handler.dart';
import 'package:dependencies/dartz/dartz.dart';

class MarketRepositoryImpl implements MarketRepository {
  final SocketDataSource socketDataSource;

  MarketRepositoryImpl(this.socketDataSource);

  @override
  Stream<Either<FailureResponse, Trade>> streamTradeData(String symbol) {
    socketDataSource.connect('$symbol@trade');

    return socketDataSource.stream.map<Either<FailureResponse, Trade>>((data) {
      try {
        final json = jsonDecode(data);
        final trade = TradeModel.fromJson(json);
        return Right(trade);
      } catch (e) {
        return Left(FailureResponse(statusCode: 500, errorMessage: 'Parsing error: $e'));
      }
    }).handleError((error) {
      return Left(FailureResponse(statusCode: 500, errorMessage: 'Socket error: $error'));
    });
  }

  @override
  Stream<Either<FailureResponse, Trade>> streamTradeMultipleData(List<String> symbols) {
    return socketDataSource.connectMultiple(symbols).map((event) {
      try {
        final jsonData = jsonDecode(event);
        final stream = jsonData['stream']; // e.g. 'btcusdt@trade'
        final data = jsonData['data'];
        final trade = TradeModel.fromJson(data);
        return Right(trade);
      } catch (e) {
        return Left(FailureResponse(statusCode: 500, errorMessage: 'Socket error: $e'));
      }
    });
  }

  @override
  void disconnect() {
    socketDataSource.disconnect();
  }

  @override
  void reconnect() {
    socketDataSource.reconnect();
  }

  @override
  Stream<ConnectionStatus> getConnectionStatus() {
    return socketDataSource.connectionStatus;
  }
}
