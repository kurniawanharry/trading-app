# matcha ID

A Trading Simulation App

Cara run project:  
  flutter run -t lib/launcher/main_dev.dart  --dart-define=FLAVOR=dev
atau:  
  flutter run -t lib/launcher/main_dev.dart --flavor=dev

Library yang digunakan:  
  web_socket_channel: ^3.0.3  
  https://pub.dev/packages/web_socket_channel

Reason:  
  Karena Binance menggunakan WebSocket untuk data marketnya secara real-time

Struktur folder & arsitektur  
  Package-based-modular-architecture

Availabel for:
  iOS,
  Android,
  Web,
  Desktop

Teknologi :
1. Flutter 3.29+, null safety
2. State Management: Bloc/Cubit,
3. Local Storage: SharedPreferences
