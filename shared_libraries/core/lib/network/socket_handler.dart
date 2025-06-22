import 'dart:async';

import 'package:commons_domain/data/models/markets/enum/markets_enum.dart';
import 'package:dependencies/shared_preferences/shared_preferences.dart';
import 'package:dependencies/web_socket/web_socket.dart';
import 'package:dependencies/web_socket/web_socket.dart' as status;

abstract class SocketDataSource {
  Stream<dynamic> get stream;

  Stream<dynamic> connect(String streamPath);
  Stream<dynamic> connectMultiple(List<String> streamPaths);
  void disconnect();
  void reconnect();

  Stream<ConnectionStatus> get connectionStatus;
}

class SocketHandler implements SocketDataSource {
  final String socketBaseUrl;
  final SharedPreferences sharedPreferences;

  WebSocketChannel? _channel;
  StreamController<dynamic>? _controller;
  final StreamController<ConnectionStatus> _statusController = StreamController.broadcast();
  String? _currentPath;

  SocketHandler(
    this.sharedPreferences, {
    required this.socketBaseUrl,
  });

  /// Connects to a WebSocket stream path like 'btcusdt@trade'
  @override
  Stream<dynamic> connect(String streamPath) {
    disconnect(); // Close existing connection

    _currentPath = streamPath;
    _controller = StreamController.broadcast();
    _statusController.add(ConnectionStatus.reconnecting);

    final uri = Uri.parse('$socketBaseUrl/ws/$streamPath');

    try {
      _channel = WebSocketChannel.connect(uri);
      _statusController.add(ConnectionStatus.connected);
    } catch (e) {
      _statusController.add(ConnectionStatus.error);
      _controller!.addError('WebSocket connection failed: $e');
      return _controller!.stream;
    }

    _channel!.stream.listen(
      (data) {
        _controller!.add(data);
      },
      onError: (error) {
        _statusController.add(ConnectionStatus.error);
        _controller!.addError('WebSocket stream error: $error');
      },
      onDone: () {
        _statusController.add(ConnectionStatus.disconnected);
        _controller!.close();
      },
      cancelOnError: true,
    );

    return _controller!.stream;
  }

  @override
  Stream<ConnectionStatus> get connectionStatus => _statusController.stream;

  /// Disconnects the WebSocket cleanly
  @override
  void disconnect() {
    _channel?.sink.close(status.normalClosure);
    _statusController.add(ConnectionStatus.disconnected);
    _channel = null;

    if (_controller != null && !_controller!.isClosed) {
      _controller?.close();
    }

    _controller = null;
  }

  /// Reconnect to the last connected stream path
  @override
  void reconnect() {
    if (_currentPath != null) {
      connect(_currentPath!);
    }
  }

  /// Get the active stream safely
  @override
  Stream<dynamic> get stream {
    if (_controller == null) {
      throw StateError(
        'Stream has not been initialized. Call connect() first.',
      );
    }
    return _controller!.stream;
  }

  @override
  Stream connectMultiple(List<String> streamPaths) {
    disconnect();

    _currentPath = streamPaths.join('/');
    _controller = StreamController.broadcast();
    _statusController.add(ConnectionStatus.reconnecting);

    final uri = Uri.parse('$socketBaseUrl/stream?streams=$_currentPath');

    try {
      _channel = WebSocketChannel.connect(uri);
      _statusController.add(ConnectionStatus.connected);
    } catch (e) {
      _statusController.add(ConnectionStatus.error);
      _controller!.addError('WebSocket connection failed: $e');
      return _controller!.stream;
    }

    _channel!.stream.listen(
      (data) {
        _controller!.add(data);
      },
      onError: (error) {
        _statusController.add(ConnectionStatus.error);
        _controller!.addError(error);
      },
      onDone: () {
        _statusController.add(ConnectionStatus.disconnected);
        _controller!.close();
      },
      cancelOnError: true,
    );

    return _controller!.stream;
  }
}
