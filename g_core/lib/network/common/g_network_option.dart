import 'package:g_common/g_common.dart';
import 'package:g_core/network/common/g_certificate_config.dart';

abstract class GNetworkOption {}

class HttpNetworkOption extends GNetworkOption {
  final String baseUrl;
  final GJson defaultHeaders;
  final Duration timeout;
  final GCertificateConfig? certificateConfig;

  HttpNetworkOption({
    required this.baseUrl,
    this.defaultHeaders = const {},
    this.timeout = const Duration(seconds: 30),
    this.certificateConfig,
  });
}

class SocketNetworkOption extends GNetworkOption {
  final String baseUrl;
  final String? token;
  final bool autoConnect;
  final bool reconnect;

  SocketNetworkOption({
    required this.baseUrl,
    this.token,
    this.autoConnect = true,
    this.reconnect = true,
  });
}
