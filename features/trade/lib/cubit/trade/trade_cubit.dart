import 'dart:async';

import 'package:common/error/failure_response.dart';
import 'package:common/state/view_data_state.dart';
import 'package:commons_domain/data/models/markets/response/coin_gecko_coin.dart';
import 'package:commons_domain/data/models/markets/response/ticker_model.dart';
import 'package:commons_domain/data/models/trades/response/simulated_trade.dart';
import 'package:commons_domain/domain/usecase/market/stream_market_usecase.dart';
import 'package:commons_domain/domain/usecase/trade/trade_history_usecase.dart';
import 'package:commons_domain/domain/usecase/trade/trade_record_usecase.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:dependencies/equatable/equatable.dart';
import 'package:market/cubit/market_cubit.dart';

part 'trade_state.dart';

class TradeCubit extends Cubit<TradeState> {
  final TradeHistoryUsecase tradeHistoryUsecase;
  final TradeRecordUsecase tradeRecordUsecase;
  final StreamMarketUsecase streamMarketUsecase;
  final MarketCubit marketCubit;

  StreamSubscription<Either<FailureResponse, TickerData>>? _selectedSubscription;

  TradeCubit({
    required this.tradeHistoryUsecase,
    required this.tradeRecordUsecase,
    required this.streamMarketUsecase,
    required this.marketCubit,
  }) : super(
          TradeState(
            tradeState: ViewData.initial(),
            selectedMarketState: ViewData.initial(),
            tradeSubmit: ViewData.loaded(data: false),
          ),
        );

  fetchGeckoCoin() {
    var gecko = marketCubit.state.geckoState.data;
    var data = gecko?.first;
    emit(state.copyWith(coinGeckoCoin: data));
    emit(state.copyWith(coinList: ViewData.loaded(data: gecko)));
  }

  streamSelectedSymbol(String symbol) {
    _selectedSubscription?.cancel();

    _selectedSubscription = streamMarketUsecase(symbol).listen((result) {
      result.fold(
        (failure) {
          emit(state.copyWith(
            selectedMarketState: ViewData.error(
              failure: failure,
              message: failure.errorMessage.toString(),
            ),
          ));
        },
        (trade) {
          emit(state.copyWith(
            selectedMarketState: ViewData.loaded(data: trade),
          ));
        },
      );
    });
  }

  submit({bool isBuy = true, double? price, double? amount}) async {
    final trade = SimulatedTrade(
      symbol: state.coinGeckoCoin?.symbol ?? '',
      price: price ?? 0,
      quantity: amount ?? 0,
      total: (price ?? 0) * (amount ?? 0),
      isBuy: isBuy,
      timestamp: DateTime.now(),
    );

    try {
      await tradeRecordUsecase.call(trade);
      emit(state.copyWith(tradeSubmit: ViewData.loaded(data: true)));
    } catch (e) {
      emit(state.copyWith(
        tradeSubmit: ViewData.error(
          failure: FailureResponse(errorMessage: e.toString()),
          message: 'Error',
        ),
      ));
    }
  }

  updateCoin(CoinGeckoCoin? coinGeckoCoin) {
    emit(
      state.copyWith(coinGeckoCoin: coinGeckoCoin),
    );

    streamSelectedSymbol(cryptoSymbol(coinGeckoCoin?.symbol ?? ''));
  }

  reset() {
    state.copyWith(
      tradeState: ViewData.initial(),
      selectedMarketState: ViewData.initial(),
      tradeSubmit: ViewData.loaded(data: false),
    );
  }

  String cryptoSymbol(String symbol) {
    switch (symbol.toUpperCase()) {
      case 'ETH':
        return 'ethusdt';
      case 'DOGE':
        return 'dogeusdt';
      case 'ADA':
        return 'adausdt';
      case 'SOL':
        return 'solusdt';
      case 'TRX':
        return 'trxusdt';
      default:
        return 'btcusdt';
    }
  }
}
