import 'dart:async';

import 'package:g_common/constants/g_typedef.dart';
import 'package:g_common/utils/g_logger.dart' show Logger;
import 'package:g_core/network/common/g_network_executor.dart'
    show GNetworkExecutor;
import 'package:g_core/network/common/g_network_option.dart'
    show GNetworkOption, SocketNetworkOption;
import 'package:g_core/network/common/g_network_type.dart';
import 'package:g_core/network/strategy/g_network_strategy.dart';
import 'package:g_lib/g_lib_network.dart';

class GSocketNetworkStrategy extends GNetworkStrategy
    with GNetworkExecutor
    implements GSocketStrategy {
  late final Socket _socket;
  bool _isConnected = false;
  Socket? get socket => _socket;
  final Map<String, StreamController<GJson>> _streamControllers = {};
  final Map<String, GJson> _subscribedChannels = {};

  GSocketNetworkStrategy([SocketNetworkOption? options]) {
    _initializeSocket(options);
  }

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> connect() async {
    if (isConnected) return;
    _registerSocketHandlers();
    _socket.connect();
  }

  @override
  Future<void> disconnect() async {
    _isConnected = false;
    _socket.disconnect();
    _socket.destroy();
    for (var controller in _streamControllers.values) {
      controller.close();
    }
    _streamControllers.clear();
    _subscribedChannels.clear();
    Logger.d('Socket disconnected');
  }

  @override
  Future<void> emit({required String event, required data}) async {
    if (!_isConnected) throw Exception("소켓 연결이 되어 있지 않습니다.");
    _socket.emit(event, data);
  }

  @override
  void on({required String event, Function(dynamic data)? handler}) {
    if (!_isConnected) throw Exception("소켓 연결이 되어 있지 않습니다.");
    _socket.on(event, (data) {
      handler?.call(data);
    });
  }

  @override
  Stream<GJson> subscribe({required String event, GJson? payload}) {
    if (!_streamControllers.containsKey(event)) {
      final controller = StreamController<GJson>.broadcast();
      _streamControllers[event] = controller;
      // 서버에 구독 요청
      _socket.emit('subscribe', {
        'channel': event,
        if (payload != null) 'data': payload,
      });

      // 구독 정보 저장
      _subscribedChannels[event] = payload ?? {};
    }
    return _streamControllers[event]!.stream;
  }

  @override
  Future<void> unsubscribe({required String event}) async {
    _socket.off(event);
    await _streamControllers[event]?.close();
    _streamControllers.remove(event);
  }

  @override
  Future<GJson> sendWithAck(
    String channel,
    GJson data, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (!_isConnected) throw Exception('Socket not connected');

    final completer = Completer<GJson>();

    _socket.emitWithAck(channel, data, ack: (dynamic response) {
      if (!completer.isCompleted) {
        if (response is Map) {
          completer.complete(Map<String, dynamic>.from(response));
        } else {
          completer.complete({'raw': response});
        }
      }
    });

    return completer.future.timeout(timeout, onTimeout: () {
      throw TimeoutException(
          'Socket ack timed out after ${timeout.inSeconds}s');
    });
  }

  @override
  Future<void> reinitializeWithOptions(GNetworkOption options) async {
    if (options is! SocketNetworkOption) {
      throw ArgumentError(
        'Expected SocketNetworkOption but received ${options.runtimeType}',
      );
    }

    // 기존 소켓 연결 정리
    if (_isConnected) {
      await disconnect();
    }

    // 새로운 옵션으로 소켓 재초기화
    _initializeSocket(options);
  }

  void _initializeSocket([SocketNetworkOption? options]) {
    final optionBuilder = OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect() // 수동 연결
        .enableReconnection() // 자동 재연결
        .setExtraHeaders({
          if (options?.token != null)
            'Authorization': 'Bearer ${options?.token}',
        })
        .build();

    // URL이 null인 경우 기본값 설정
    final socketUrl = options?.baseUrl ?? 'http://localhost:3000';
    _socket = io(socketUrl, optionBuilder);
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    _socket
      ..onConnect(_onConnect)
      ..onDisconnect(_onDisconnect)
      ..onReconnect(_onReconnect)
      ..onError(_onError);
  }

  void _registerSocketHandlers() {
    _socket
      ..onConnect(_onConnect)
      ..onDisconnect(_onDisconnect)
      ..onReconnect(_onReconnect)
      ..onError(_onError);
  }

  void _onConnect(_) {
    _isConnected = true;
    Logger.i("✅ Socket connected");

    // 모든 채널 공통 이벤트 수신
    _socket.on('event', _handleChannelEvent);
  }

  void _onDisconnect(_) {
    _isConnected = false;
    Logger.w("🛑 Socket disconnected");
  }

  Future<void> _onReconnect(_) async {
    Logger.i("🔁 Reconnected. Resubscribing...");
    try {
      await _resubscribeAll();
    } catch (e) {
      Logger.e("재구독 실패 $e");
    }
  }

  void _onError(dynamic data) {
    Logger.e('❗ Socket error: $data');
  }

  void _handleChannelEvent(dynamic data) {
    if (data is! Map ||
        !data.containsKey('channel') ||
        !data.containsKey('data')) {
      Logger.w("📭 이벤트 데이터 형식 오류: $data");
      return;
    }

    final channel = data['channel'];
    final payload = data['data'];

    final controller = _streamControllers[channel];
    if (controller != null && !controller.isClosed) {
      controller.add(payload);
    } else {
      Logger.w("❗️등록되지 않은 채널 수신: $channel");
    }
  }

  Future<void> _resubscribeAll() async {
    for (final entry in _subscribedChannels.entries) {
      _socket.emit('subscribe', {
        'channel': entry.key,
        if (entry.value.isNotEmpty) 'data': entry.value,
      });
    }
  }

  @override
  Future<void> switchTo(
      {required GNetworkType type, GNetworkOption? options}) async {
    if (type == GNetworkType.http) {
      await disconnect();
    }
  }
}
