/// 앱 라이프사이클 옵션
class GAppLifecycleOption {
  /// 자동 초기화 여부
  final bool autoInitialize;

  /// 스트림 브로드캐스트 사용 여부
  final bool useBroadcast;

  /// 디버그 모드 여부
  final bool debug;

  const GAppLifecycleOption({
    this.autoInitialize = true,
    this.useBroadcast = true,
    this.debug = false,
  });

  GAppLifecycleOption copyWith({
    bool? autoInitialize,
    bool? useBroadcast,
    bool? debug,
  }) {
    return GAppLifecycleOption(
      autoInitialize: autoInitialize ?? this.autoInitialize,
      useBroadcast: useBroadcast ?? this.useBroadcast,
      debug: debug ?? this.debug,
    );
  }
}
