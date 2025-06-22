import 'package:common/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:onboarding/bloc/splash_bloc/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState(splashState: ViewData.initial()));

  void initSplash() async {
    await Future.delayed(const Duration(seconds: 1));
    emit(SplashState(splashState: ViewData.loaded()));
  }
}
