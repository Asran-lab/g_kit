/// Certificate Pinning 설정 클래스
class GCertificateConfig {
  /// Certificate Pinning을 사용할 도메인과 해당 SHA256 핀
  final Map<String, List<String>> domainPins;

  /// Certificate Pinning 활성화 여부
  final bool enabled;

  /// Certificate Pinning 검증 실패 시 허용할지 여부 (개발환경용)
  final bool allowBadCertificates;

  const GCertificateConfig({
    this.domainPins = const {},
    this.enabled = false,
    this.allowBadCertificates = false,
  });

  /// 개발환경용 설정 (Certificate Pinning 비활성화)
  static const GCertificateConfig development = GCertificateConfig(
    enabled: false,
    allowBadCertificates: true,
  );

  /// 스테이징환경용 설정 (경고만 표시)
  static const GCertificateConfig staging = GCertificateConfig(
    enabled: true,
    allowBadCertificates: true,
  );

  /// 프로덕션환경용 설정 (엄격한 Certificate Pinning)
  static GCertificateConfig production({
    required Map<String, List<String>> pins,
  }) =>
      GCertificateConfig(
        domainPins: pins,
        enabled: true,
        allowBadCertificates: false,
      );

  /// 특정 도메인에 대한 SHA256 핀 목록 반환
  List<String>? getPinsForDomain(String domain) {
    return domainPins[domain];
  }

  /// 도메인이 Certificate Pinning 대상인지 확인
  bool shouldPinDomain(String domain) {
    return enabled && domainPins.containsKey(domain);
  }
}

/// Certificate Pinning 관련 유틸리티 클래스
class GCertificateUtils {
  /// Certificate 핀 검증
  ///
  /// [domain] 검증할 도메인
  /// [certificatePin] 검증할 인증서 핀
  /// [config] Certificate Pinning 설정
  ///
  /// Returns: 검증 성공 시 true, 실패 시 false
  static bool validateCertificatePin(
    String domain,
    String certificatePin,
    GCertificateConfig config,
  ) {
    // Certificate Pinning이 비활성화된 경우 모든 핀 허용
    if (!config.enabled) {
      return true;
    }

    // allowBadCertificates가 true인 경우 모든 핀 허용 (스테이징 환경)
    if (config.allowBadCertificates) {
      return true;
    }

    // 해당 도메인의 핀 목록 가져오기
    final domainPins = config.getPinsForDomain(domain);

    // 도메인이 설정되지 않은 경우 실패
    if (domainPins == null || domainPins.isEmpty) {
      return false;
    }

    // 핀 목록에 포함되어 있는지 확인
    return domainPins.contains(certificatePin);
  }

  /// Certificate 핀이 올바른 형식인지 검증
  ///
  /// [pin] 검증할 Certificate 핀
  ///
  /// Returns: 올바른 형식이면 true
  static bool isValidCertificatePin(String pin) {
    // Base64 형식 기본 검증 (길이와 문자)
    if (pin.isEmpty) return false;

    // SHA256 해시의 Base64 인코딩은 보통 44자 또는 43자 + 패딩
    if (pin.length < 40) return false;

    // Base64 문자 검증 (A-Z, a-z, 0-9, +, /, =)
    final base64Regex = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    return base64Regex.hasMatch(pin);
  }

  /// SHA256 핀 생성 예시 (실제로는 서버 인증서에서 추출해야 함)
  static const Map<String, List<String>> examplePins = {
    'api.example.com': [
      // Primary certificate SHA256
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
      // Backup certificate SHA256
      'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=',
    ],
    'yourdomain.com': [
      // Primary certificate SHA256
      'CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC=',
      // Backup certificate SHA256
      'DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD=',
    ],
  };
}
