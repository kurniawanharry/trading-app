import 'dart:convert';

import 'package:common/error/failure_response.dart';
import 'package:commons_domain/data/models/markets/enum/markets_enum.dart';
import 'package:commons_domain/data/models/markets/response/ticker_model.dart';
import 'package:commons_domain/domain/repository/market_repository.dart';
import 'package:core/network/socket_handler.dart';
import 'package:dependencies/dartz/dartz.dart';

class MarketRepositoryImpl implements MarketRepository {
  final SocketDataSource socketDataSource;

  MarketRepositoryImpl(this.socketDataSource);

  @override
  Stream<Either<FailureResponse, TickerData>> streamTradeData(String symbol) {
    return socketDataSource
        .connect('$symbol@ticker')
        .map<Either<FailureResponse, TickerData>>((event) {
      try {
        final jsonData = jsonDecode(event);

        // Fallback to jsonData if 'data' not found
        final data = jsonData['data'] ?? jsonData;

        final trade = TickerData.fromJson(data);
        return Right(trade);
      } catch (e) {
        return Left(FailureResponse(statusCode: 500, errorMessage: 'Parsing error: $e'));
      }
    }).handleError((error) {
      return Left(FailureResponse(statusCode: 500, errorMessage: 'Socket error: $error'));
    });
  }

  @override
  Stream<Either<FailureResponse, TickerData>> streamTradeMultipleData(List<String> symbols) {
    return socketDataSource.connectMultiple(symbols).map((event) {
      try {
        final jsonData = jsonDecode(event);
        // final stream = jsonData['stream']; // e.g. 'btcusdt@trade'
        final data = jsonData['data'];
        final trade = TickerData.fromJson(data);
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
