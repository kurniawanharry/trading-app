part of 'trade_cubit.dart';

class TradeState extends Equatable {
  final ViewData<String> tradeState;
  final ViewData<bool> tradeSubmit;
  final ViewData<TickerData> selectedMarketState; // NEW
  final CoinGeckoCoin? coinGeckoCoin;
  final ViewData<List<CoinGeckoCoin>>? coinList;
  const TradeState({
    required this.tradeState,
    required this.selectedMarketState,
    required this.tradeSubmit,
    this.coinGeckoCoin,
    this.coinList,
  });

  TradeState copyWith({
    ViewData<String>? tradeState,
    ViewData<bool>? tradeSubmit,
    CoinGeckoCoin? coinGeckoCoin,
    ViewData<List<CoinGeckoCoin>>? coinList,
    ViewData<TickerData>? selectedMarketState,
  }) {
    return TradeState(
      tradeSubmit: tradeSubmit ?? this.tradeSubmit,
      tradeState: tradeState ?? this.tradeState,
      coinGeckoCoin: coinGeckoCoin ?? this.coinGeckoCoin,
      coinList: coinList ?? this.coinList,
      selectedMarketState: selectedMarketState ?? this.selectedMarketState,
    );
  }

  @override
  List<Object?> get props =>
      [tradeState, coinGeckoCoin, coinList, selectedMarketState, tradeSubmit];
}
