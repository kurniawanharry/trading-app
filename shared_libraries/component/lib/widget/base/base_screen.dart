import 'package:common/navigation/router/auth_router.dart';
import 'package:dependencies/get_it/get_it.dart';

mixin BaseScreen {
  final AuthRouter _authRouter = sl();

  AuthRouter get authRouter => _authRouter;
}
