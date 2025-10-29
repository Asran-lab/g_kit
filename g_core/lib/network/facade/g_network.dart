import 'package:g_common/g_common.dart';
import 'package:g_core/network/common/g_network_option.dart';
import 'package:g_core/network/common/g_network_type.dart';
import 'package:g_core/network/context/g_network_context.dart';
import 'package:g_core/network/g_network_initializer.dart';
import 'package:g_lib/g_lib_network.dart';
import 'package:g_model/g_model.dart';

/// 네트워크 Facade 클래스
///
/// GContextFacade를 상속하여 표준화된 패턴을 따릅니다.
class GNetwork extends GContextFacade<GNetworkContext, GNetworkInitializer> {
  GNetwork._() : super(GNetworkInitializer());
  static final GNetwork _instance = GNetwork._();

  /// 네트워크 컨텍스트 초기화
  static void initialize({
    HttpNetworkOption? httpOptions,
    SocketNetworkOption? socketOptions,
  }) {
    // GNetworkInitializer는 싱글톤이므로 직접 접근
    GNetworkInitializer().configure(
      httpOptions: httpOptions,
      socketOptions: socketOptions,
    );
  }

  /// 전략 전환
  static Future<void> switchTo({
    required GNetworkType type,
    GNetworkOption? options,
  }) async {
    await _instance.context.switchTo(type: type, options: options);
  }

  /// 연결 상태 확인
  static bool get isConnected => _instance.context.isConnected;

  // HTTP 메서드들
  static Future<GEither<GException, GResponse<T>>> get<T>({
    required String path,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
    bool? isCache = true,
  }) {
    return _instance.context.get<T>(
      path: path,
      headers: headers,
      queryParameters: queryParameters,
      options: options,
      fromJsonT: fromJsonT,
      isCache: isCache,
    );
  }

  static Future<GEither<GException, GResponse<T>>> post<T>({
    required String path,
    Object? data,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  }) {
    return _instance.context.post<T>(
      path: path,
      data: data,
      headers: headers,
      queryParameters: queryParameters,
      options: options,
      fromJsonT: fromJsonT,
    );
  }

  static Future<GEither<GException, GResponse<T>>> put<T>({
    required String path,
    Object? data,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  }) {
    return _instance.context.put<T>(
      path: path,
      data: data,
      headers: headers,
      queryParameters: queryParameters,
      options: options,
      fromJsonT: fromJsonT,
    );
  }

  static Future<GEither<GException, GResponse<T>>> patch<T>({
    required String path,
    Object? data,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  }) {
    return _instance.context.patch<T>(
      path: path,
      data: data,
      headers: headers,
      queryParameters: queryParameters,
      options: options,
      fromJsonT: fromJsonT,
    );
  }

  static Future<GEither<GException, GResponse<T>>> delete<T>({
    required String path,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  }) {
    return _instance.context.delete<T>(
      path: path,
      headers: headers,
      queryParameters: queryParameters,
      options: options,
      fromJsonT: fromJsonT,
    );
  }

  // Socket 메서드들
  static Future<void> connect() => _instance.context.connect();
  static Future<void> disconnect() => _instance.context.disconnect();

  static void on({
    required String event,
    Function(dynamic data)? handler,
  }) {
    _instance.context.on(event: event, handler: handler);
  }

  static Future<void> emit({
    required String event,
    required dynamic data,
  }) {
    return _instance.context.emit(event: event, data: data);
  }

  static Stream<GJson> subscribe({
    required String event,
    GJson? payload,
  }) {
    return _instance.context.subscribe(event: event, payload: payload);
  }

  static Future<void> unsubscribe({required String event}) {
    return _instance.context.unsubscribe(event: event);
  }

  static Future<GJson> sendWithAck(
    String channel,
    GJson data, {
    Duration timeout = const Duration(seconds: 5),
  }) {
    return _instance.context.sendWithAck(channel, data, timeout: timeout);
  }
}
