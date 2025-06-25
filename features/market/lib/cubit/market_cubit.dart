import 'dart:async';

import 'package:common/error/failure_response.dart';
import 'package:common/state/view_data_state.dart';
import 'package:commons_domain/data/models/markets/response/coin_gecko_coin.dart';
import 'package:commons_domain/data/models/markets/response/coin_ticker.dart';
import 'package:commons_domain/data/models/markets/response/ticker_model.dart';
import 'package:commons_domain/domain/usecase/market/gecko_usecase.dart';
import 'package:commons_domain/domain/usecase/market/stream_market_multiple_usecase.dart';
import 'package:commons_domain/domain/usecase/market/stream_market_usecase.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:dependencies/equatable/equatable.dart';

part 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  final StreamMarketUsecase streamMarketUsecase;
  final StreamMarketMultipleUsecase streamMarketMultipleUsecase;
  final GeckoUsecase geckoUsecase;

  StreamSubscription<Either<FailureResponse, TickerData>>? _subscription;

  final Map<String, CoinTicker> _tickerMap = {};

  MarketCubit({
    required this.streamMarketUsecase,
    required this.streamMarketMultipleUsecase,
    required this.geckoUsecase,
  }) : super(
          MarketState(marketState: ViewData.initial(), geckoState: ViewData.initial()),
        );

  fetchGeckoCoin(List<String> ids) async {
    emit(state.copyWith(geckoState: ViewData.loading()));
    final result = await geckoUsecase.call(ids);
    result.fold(
      (failure) {
        emit(state.copyWith(
            geckoState:
                ViewData.error(failure: failure, message: failure.errorMessage.toString())));
      },
      (coinGeckoCoin) {
        // Initialize once from Gecko
        if (coinGeckoCoin.isNotEmpty) {
          final initialMap = {
            for (final coin in coinGeckoCoin)
              '${coin.symbol.toUpperCase()}USDT': CoinTicker(
                  symbol: '${coin.symbol.toUpperCase()}USDT',
                  baseAsset: coin.symbol.toUpperCase(),
                  name: coin.name,
                  imageUrl: coin.image,
                  price: 0.0,
                  priceChangePercentage24h: 0.0),
          };
          _tickerMap.addAll(initialMap);
        }
        emit(state.copyWith(geckoState: ViewData.loaded(data: coinGeckoCoin)));
      },
    );
  }

  streamMultiple(List<String> symbols) {
    emit(state.copyWith(marketState: ViewData.loading()));
    _subscription?.cancel();

    // Start listening to live updates
    _subscription = streamMarketMultipleUsecase(symbols).listen((result) {
      result.fold(
        (failure) {
          emit(state.copyWith(
            marketState: ViewData.error(
              failure: failure,
              message: failure.errorMessage.toString(),
            ),
          ));
        },
        (trade) {
          final symbol = trade.symbol.toUpperCase();
          final price = trade.lastPrice;
          final priceChange =
              trade.openPrice != 0 ? ((price - trade.openPrice) / trade.openPrice) * 100 : 0.0;

          final existing = _tickerMap[symbol];
          if (existing != null) {
            final updated = existing.copyWith(price: price, priceChangePercentage: priceChange);
            _tickerMap[symbol] = updated;
            emit(state.copyWith(marketState: ViewData.loaded(data: Map.from(_tickerMap))));
          }
        },
      );
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}


  // streamMarket(String symbol) {
    // emit(state.copyWith(marketState: ViewData.loading()));
    // _subscription?.cancel();

    // _subscription = streamMarketUsecase(symbol).listen(
    //   (result) {
    //     result.fold(
    //       (failure) => emit(
    //         state.copyWith(
    //           marketState: ViewData.error(
    //               failure: FailureResponse(errorMessage: failure.errorMessage.toString()),
    //               message: failure.errorMessage.toString()),
    //         ),
    //       ),
    //       (trade) => emit(
    //         state.copyWith(marketState: ViewData.loaded(data: trade)),
    //       ),
    //     );
    //   },
    // );
  // }