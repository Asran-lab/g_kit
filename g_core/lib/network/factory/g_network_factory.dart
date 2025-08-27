import 'package:g_core/network/common/g_network_option.dart';
import 'package:g_core/network/context/g_network_context.dart';
import 'package:g_core/network/strategy/impl/g_http_network_strategy.dart';
import 'package:g_core/network/strategy/impl/g_socket_network_strategy.dart';

/// 네트워크 팩토리 클래스
/// HTTP와 Socket 전략을 생성하고 컨텍스트를 구성합니다.
class GNetworkFactory {
  /// HTTP 전략 생성
  static GHttpNetworkStrategy createHttpStrategy([HttpNetworkOption? options]) {
    return GHttpNetworkStrategy(options);
  }

  /// Socket 전략 생성
  static GSocketNetworkStrategy createSocketStrategy(
      [SocketNetworkOption? options]) {
    return GSocketNetworkStrategy(options);
  }

  /// 네트워크 컨텍스트 생성
  static GNetworkContext createContext({
    HttpNetworkOption? httpOptions,
    SocketNetworkOption? socketOptions,
    GHttpNetworkStrategy? httpStrategy,
    GSocketNetworkStrategy? socketStrategy,
  }) {
    // final httpStrategy = createHttpStrategy(httpOptions);
    // final socketStrategy = createSocketStrategy(socketOptions);

    return GNetworkContext(
      httpStrategy: httpStrategy,
      socketStrategy: socketStrategy,
      httpOption: httpOptions,
      socketOption: socketOptions,
    );
  }

  /// 기본 설정으로 네트워크 컨텍스트 생성
  static GNetworkContext createDefaultContext() {
    return createContext();
  }
}
