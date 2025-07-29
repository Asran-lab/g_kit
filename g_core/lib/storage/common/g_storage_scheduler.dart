import 'dart:async' show Timer;

import 'package:g_common/utils/g_guard.dart' show guardFuture;
import 'package:g_common/utils/g_logger.dart' show Logger;
import 'package:g_core/storage/context/g_storage_context.dart';

class GStorageScheduler {
  static Timer? _timer;
  static Duration _interval = const Duration(hours: 1); // 기본 1시간마다
  static bool _isRunning = false;

  /// 스케줄러 시작
  ///
  /// [interval] - 정리 주기 (기본: 1시간)
  static void start({Duration? interval}) {
    if (_isRunning) {
      stop(); // 기존 스케줄러 중지
    }

    _interval = interval ?? _interval;
    _isRunning = true;

    _timer = Timer.periodic(_interval, (timer) async {
      await _performCleanup();
    });

    Logger.d('🕐 Storage 스케줄러 시작됨 (주기: ${_interval.inMinutes}분)');
  }

  /// 스케줄러 중지
  static void stop() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    Logger.d('⏹️ Storage 스케줄러 중지됨');
  }

  /// 스케줄러 실행 상태 확인
  static bool get isRunning => _isRunning;

  /// 현재 설정된 정리 주기
  static Duration get interval => _interval;

  /// 수동으로 정리 실행
  static Future<void> performCleanupNow() async {
    await _performCleanup();
  }

  /// 실제 정리 작업 수행
  static Future<void> _performCleanup() async {
    await guardFuture<void>(() async {
      Logger.d('🧹 Storage 만료 데이터 정리 시작...');

      // 모든 Storage 타입에서 만료된 데이터 정리
      await GStorageContext().cleanupExpired();

      Logger.d('✅ Storage 만료 데이터 정리 완료');
    });
  }

  /// 스케줄러 정보 출력
  static Map<String, dynamic> getInfo() {
    return {
      'isRunning': _isRunning,
      'interval': '${_interval.inMinutes}분',
      'nextCleanup': _timer != null
          ? DateTime.now().add(_interval).toIso8601String()
          : null,
    };
  }
}
