import 'package:common/constants/application_configs.dart';
import 'package:common/utils/utils.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:matcha_id/injections/injections.dart';
import 'package:matcha_id/root/application_root.dart';

Future<void> main() async {
  Bloc.observer = MainBlocObserver();
  Config.appFlavor = Flavor.staging;
  WidgetsFlutterBinding.ensureInitialized();
  await Injections().initialize(baseUrl: Config.baseURL, socketUrl: Config.socketUrl);
  runApp(const ApplicationRoot());
}
