import 'package:common/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/equatable/equatable.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainState(mainState: ViewData.initial()));

  onSelectedTab(int index) {
    emit(
      state.copyWith(
        selectedTabIndex: index,
        mainState: ViewData.initial(),
      ),
    );
  }
}
