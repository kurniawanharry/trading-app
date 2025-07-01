import 'package:common/error/failure_response.dart';
import 'package:common/state/view_data_state.dart';
import 'package:commons_domain/data/models/portofolio/response/portofolio_item.dart';
import 'package:commons_domain/data/models/trades/response/simulated_trade.dart';
import 'package:commons_domain/domain/usecase/trade/trade_history_usecase.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/equatable/equatable.dart';
import 'package:market/cubit/market_cubit.dart';

part 'porto_state.dart';

class PortoCubit extends Cubit<PortoState> {
  final TradeHistoryUsecase tradeHistoryUsecase;
  final MarketCubit marketCubit;

  PortoCubit({
    required this.tradeHistoryUsecase,
    required this.marketCubit,
  }) : super(PortoState(marketState: ViewData.initial())) {
    loadPortfolio();
  }

  Future<void> loadPortfolio() async {
    emit(state.copyWith(marketState: ViewData.loading()));

    try {
      final result = await tradeHistoryUsecase.call('');
      final prices = marketCubit.state.marketState.data;

      result.fold(
        (l) {
          emit(state.copyWith(
            marketState: ViewData.error(failure: l, message: l.errorMessage),
          ));
        },
        (trades) {
          final Map<String, List<SimulatedTrade>> grouped = {};

          for (var trade in trades) {
            grouped.putIfAbsent(trade.symbol, () => []).add(trade);
          }

          final portfolio = <PortfolioItem>[];

          for (final entry in grouped.entries) {
            final symbol = entry.key;
            final symbolTrades = entry.value;

            double totalQty = 0;
            double totalCost = 0;

            for (var t in symbolTrades) {
              if (t.isBuy) {
                totalQty += t.quantity;
                totalCost += t.quantity * t.price;
              } else {
                totalQty -= t.quantity;
                // Optional: don't reduce totalCost unless tracking realized PnL
              }
            }

            if (totalQty > 0) {
              final formattedSymbol = '${symbol.toUpperCase()}USDT';
              final avgPrice = totalCost / totalQty;
              final name = prices?[formattedSymbol]?.name ?? '';
              final imageUrl = prices?[formattedSymbol]?.imageUrl ?? '';
              final currentPrice = prices?[formattedSymbol]?.price ?? 0.0;
              final openPrice = prices?[formattedSymbol]?.openPrice ?? 0.0;

              portfolio.add(
                PortfolioItem(
                  name: name,
                  image: imageUrl,
                  symbol: symbol,
                  totalQuantity: totalQty,
                  avgBuyPrice: avgPrice,
                  currentPrice: currentPrice,
                  openPrice: openPrice,
                ),
              );
            }
          }

          double totalPortfolioValue = portfolio.fold(0.0, (sum, item) => sum + item.totalValue);

          emit(state.copyWith(
            marketState: ViewData.loaded(data: portfolio),
            totalPortfolioValue: totalPortfolioValue,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        marketState: ViewData.error(
          failure: FailureResponse(errorMessage: e.toString()),
          message: 'Error loading portfolio',
        ),
      ));
    }
  }
}
