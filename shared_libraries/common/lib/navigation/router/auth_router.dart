import 'package:common/navigation/router/app_router.dart';

import '../navigation_helper.dart';

abstract class AuthRouter {
  void navigateToSignIn();

  void navigateToSignUp();

  void goBack({String? arguments});

  void navigateToHome();

  void navigateToMain();
}

class AuthRouterImpl implements AuthRouter {
  final NavigationHelper navigationHelper;

  AuthRouterImpl({
    required this.navigationHelper,
  });

  @override
  void navigateToSignIn() => navigationHelper.pushReplacementNamed(AppRoutes.signIn);

  @override
  void navigateToSignUp() => navigationHelper.pushNamed(AppRoutes.signUp);

  @override
  void goBack({String? arguments}) => navigationHelper.pop(arguments);

  @override
  void navigateToHome() => navigationHelper.pushReplacementNamed(AppRoutes.home);

  @override
  void navigateToMain() => navigationHelper.pushReplacementNamed(AppRoutes.main);
}
