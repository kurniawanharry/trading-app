part of 'application_root.dart';

extension ApplicationRootingExtension on ApplicationRoot {
  Map<String, WidgetBuilder> get routes => {}
    ..addAll(_routesWithoutArguments)
    ..addAll(_routesWithArguments);

  Map<String, WidgetBuilder> get _routesWithoutArguments => {};

  Map<String, WidgetBuilder> get _routesWithArguments => {};
}
