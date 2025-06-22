import 'package:authentication/di/dependency.dart';
import 'package:common/di/common_dependencies.dart';
import 'package:commons_domain/di/market.dart';
import 'package:core/di/dependency.dart';
import 'package:matcha_id/injections/shared_dependencies.dart';

class Injections {
  final sharedDependencies = SharedDependencies();
  Future<void> initialize({required String baseUrl, required String socketUrl}) async {
    _registerSharedDependencies(baseUrl: baseUrl, socketUrl: socketUrl);
    _registerDomains();
  }

  void _registerDomains() {
    AuthenticationDependency();
    MarketDependency();
  }

  Future<void> _registerSharedDependencies(
      {required String baseUrl, required String socketUrl}) async {
    RegisterCoreModule(baseUrl: baseUrl, socketUrl: socketUrl);
    CommonDependencies();
    await sharedDependencies.registerCore();
  }
}
