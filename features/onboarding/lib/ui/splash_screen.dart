import 'package:common/navigation/router/auth_router.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:onboarding/bloc/splash_bloc/splash_bloc.dart';
import 'package:onboarding/bloc/splash_bloc/splash_state.dart';
import 'package:common/state/view_data_state.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final AuthRouter authRouter = sl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state.splashState.status.isHasData) {
            authRouter.navigateToMain();
          }
        },
        child: Center(
          child: Text("Haii"),
        ),
      ),
    );
  }
}
