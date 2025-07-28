import 'package:flutter/services.dart';
import 'package:g_common/utils/g_logger.dart' show Logger;
import 'package:g_common/utils/g_guard.dart' show guardFuture;
import 'package:g_lib/g_lib_plugin.dart' as g_lib;
import '../models/share_type.dart';
import 'g_share_service.dart';

/// 공유 서비스 구현체
///
/// share_plus 패키지를 사용하여 공유 기능을 구현합니다.
class GShareImpl implements GShareService {
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    await guardFuture<void>(() async {
      // share_plus는 별도의 초기화가 필요하지 않음
      _isInitialized = true;
      Logger.d('GShareImpl initialized successfully');
    }, typeHandlers: {
      PlatformException: (e, s) {
        Logger.e('GShareImpl initialize failed', error: e);
        throw e;
      },
    });
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
  }

  @override
  Future<void> text(String text, {String? title, String? subject}) async {
    _ensureInitialized();

    await guardFuture<void>(() async {
      await g_lib.SharePlus.instance.share(
        g_lib.ShareParams(
          text: text,
          subject: subject,
        ),
      );
    }, typeHandlers: {
      PlatformException: (e, s) {
        Logger.e('Failed to share text', error: e);
        throw e;
      },
    });
  }

  @override
  Future<void> files(List<String> files,
      {String? title, String? subject, String? text}) async {
    _ensureInitialized();

    await guardFuture<void>(() async {
      await g_lib.SharePlus.instance.share(
        g_lib.ShareParams(
          files: files.map((file) => g_lib.XFile(file)).toList(),
        ),
      );
    }, typeHandlers: {
      PlatformException: (e, s) {
        Logger.e('Failed to share files', error: e);
        throw e;
      },
    });
  }

  @override
  Future<void> images(List<String> images,
      {String? title, String? subject, String? text}) async {
    _ensureInitialized();

    await guardFuture<void>(() async {
      await g_lib.SharePlus.instance.share(
        g_lib.ShareParams(
          files: images.map((image) => g_lib.XFile(image)).toList(),
        ),
      );
    }, typeHandlers: {
      PlatformException: (e, s) {
        Logger.e('Failed to share images', error: e);
        throw e;
      },
    });
  }

  @override
  Future<void> links(String link,
      {String? title, String? subject, String? text}) async {
    _ensureInitialized();

    await guardFuture<void>(() async {
      await g_lib.SharePlus.instance.share(
        g_lib.ShareParams(
          uri: Uri.parse(link),
        ),
      );
    }, typeHandlers: {
      PlatformException: (e, s) {
        Logger.e('Failed to share link', error: e);
        throw e;
      },
    });
  }

  @override
  Future<bool> canShare(ShareType type) async {
    _ensureInitialized();
    return await guardFuture<bool>(() async => true, onError: (e, s) => false);
  }

  @override
  Future<List<String>> getAvailableApps(ShareType type) async {
    _ensureInitialized();
    return await guardFuture<List<String>>(
      () async => [],
      onError: (e, s) => [],
    );
  }

  /// 초기화 상태 확인
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
          'GShareImpl is not initialized. Call initialize() first.');
    }
  }
}
