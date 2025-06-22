class AppConstants {
  const AppConstants();

  static CachedKey cachedKey = const CachedKey();

  static ErrorMessage errorMessage = const ErrorMessage();
}

class CachedKey {
  const CachedKey();

  String get tokenKey => "tokenKey";
}

class BaseUrl {
  static const String baseUrlProd = "https://megawe.serangkota.go.id/api/";
  static const String baseUrlDev = "https://megawe.serangkota.go.id/api/";
  static const String baseUrlStaging = "https://megawe.serangkota.go.id/api/";
}

class SocketUrl {
  static const String socketUrlProd = "wss://stream.binance.com:9443";
  static const String socketUrlDev = "wss://stream.binance.com:9443";
  static const String socketUrlStaging = "wss://stream.binance.com:9443";
  // wss://fstream.binance.com/ws
}
// class SocketUrl {
//   static const String socketUrlProd = "wss://fstream.binance.com";
//   static const String socketUrlDev = "wss://fstream.binance.com";
//   static const String socketUrlStaging = "wss://fstream.binance.com";
//   // wss://fstream.binance.com/ws
// }

class PackageNameIos {
  static const String backgroundFetchIosIdDev = "dev.eoatech.yaumi-dev.fetch";
  static const String backgroundFetchIosIdStg = "dev.eoatech.yaumi-dev.fetch";
  static const String backgroundFetchIosIdProd = "com.eoatech.yaumi.fetch";
}

class ErrorMessage {
  const ErrorMessage();

  String get failedGetToken => 'failed get token';
}

const String ApiKey = 'zpUlvY64PqJr9538eyJOrWlQompl49BKUrlykg6M7TK0Ltf7DcAEquu0TLay8YV6';
