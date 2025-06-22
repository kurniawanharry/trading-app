import 'package:common/navigation/navigation_helper.dart';
import 'package:common/navigation/router/app_router.dart';

abstract class SplashRouter {
  void navigatateToSignIn();
  void navigateToHome();
}

class SplashRouterImpl implements SplashRouter {
  final NavigationHelper navigationHelper;

  SplashRouterImpl(this.navigationHelper);

  @override
  void navigatateToSignIn() {
    navigationHelper.pushReplacementNamed(AppRoutes.signIn);
  }

  @override
  void navigateToHome() {
    navigationHelper.pushReplacementNamed(AppRoutes.home);
  }
}
