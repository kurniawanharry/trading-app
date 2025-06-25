import 'package:common/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/equatable/equatable.dart';

part 'trade_state.dart';

class TradeCubit extends Cubit<TradeState> {
  TradeCubit() : super(TradeState(tradeState: ViewData.initial()));
}
