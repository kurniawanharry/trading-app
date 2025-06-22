// ignore_for_file: constant_identifier_names, avoid_classes_with_only_static_members
import 'package:common/constants/app_constants.dart';

enum Flavor { development, production, staging }

class Config {
  static Flavor appFlavor = Flavor.production;

  static String get title {
    switch (appFlavor) {
      case Flavor.production:
        return "matcha ID";
      case Flavor.development:
        return "matcha ID Dev";
      case Flavor.staging:
        return "matcha ID Stg";
    }
  }

  static bool get isDebug {
    switch (appFlavor) {
      case Flavor.production:
        return false;
      case Flavor.staging:
        return false;
      case Flavor.development:
        return true;
    }
  }

  static String get backgroundFetchNotifierIOS {
    switch (appFlavor) {
      case Flavor.production:
        return PackageNameIos.backgroundFetchIosIdProd;
      case Flavor.development:
        return PackageNameIos.backgroundFetchIosIdProd;
      default:
        return PackageNameIos.backgroundFetchIosIdDev;
    }
  }

  static String get baseURL {
    switch (appFlavor) {
      case Flavor.development:
        return BaseUrl.baseUrlDev;
      case Flavor.production:
        return BaseUrl.baseUrlProd;
      case Flavor.staging:
        return BaseUrl.baseUrlStaging;
    }
  }

  static String get socketUrl {
    switch (appFlavor) {
      case Flavor.development:
        return SocketUrl.socketUrlDev;
      case Flavor.production:
        return SocketUrl.socketUrlProd;
      case Flavor.staging:
        return SocketUrl.socketUrlStaging;
    }
  }
}
