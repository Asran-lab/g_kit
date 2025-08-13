import 'dart:async';

import 'package:flutter/services.dart';
import 'package:g_common/utils/g_guard.dart' show guard, guardFuture;
import 'package:g_common/utils/g_logger.dart' show Logger;
import 'package:g_lib/g_lib_plugin.dart' as g_lib;
import 'g_stt_service.dart';

class GSttImpl implements GSttService {
  final g_lib.SpeechToText _speechToText = g_lib.SpeechToText();
  bool _initialized = false;
  bool _available = false;
  String _lastRecognizedText = '';
  void Function(String status)? _externalOnStatus;
  void Function(Object error, StackTrace? stack)? _externalOnError;

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    await guardFuture<void>(() async {
      _available = await _speechToText.initialize(
        onStatus: (status) {
          Logger.d('STT status: $status');
          final callback = _externalOnStatus;
          if (callback != null) {
            guard(() => callback(status));
          }
        },
        onError: (error) {
          Logger.e('STT error: ${error.errorMsg}');
          final callback = _externalOnError;
          if (callback != null) {
            guard(() => callback(error, null));
          }
        },
      );
      _initialized = true;
      Logger.d('GSttImpl initialized. available=$_available');
    }, typeHandlers: {
      PlatformException: (e, s) {
        Logger.e('GSttImpl initialize failed', error: e);
        throw e;
      },
    });
  }

  @override
  Future<void> dispose() async {
    await guardFuture<void>(() async {
      await _speechToText.cancel();
      _initialized = false;
      _available = false;
      _lastRecognizedText = '';
    });
  }

  @override
  Future<bool> listen({
    void Function(String recognizedWords, bool isFinal)? onResult,
    void Function(String status)? onStatus,
    void Function(Object error, StackTrace? stack)? onError,
    Duration? listenFor,
    bool partialResults = true,
    double pauseForSeconds = 3.0,
  }) async {
    _ensureInitialized();
    if (!_available) return false;

    final locale = await currentLocale();

    return await guardFuture<bool>(() async {
      _externalOnStatus = onStatus;
      _externalOnError = onError;
      onStatus?.call('listening');
      await _speechToText.listen(
        onResult: (result) {
          _lastRecognizedText = result.recognizedWords;
          final isFinal = result.finalResult;
          if (onResult != null) onResult(_lastRecognizedText, isFinal);
        },
        listenFor: listenFor,
        localeId: locale?.localeId,
        listenOptions: g_lib.SpeechListenOptions(
          partialResults: partialResults,
        ),
        pauseFor: Duration(seconds: pauseForSeconds.round()),
      );
      // plugin returns void; ensure flag reflects state
      return _speechToText.isListening;
    }, onError: (e, s) {
      Logger.e('GSttImpl listen failed', error: e);
      if (onError != null) onError(e, s);
      return false;
    });
  }

  @override
  Future<void> stop() async {
    _ensureInitialized();
    await guardFuture<void>(() async {
      await _speechToText.stop();
      // provide a simple status callback pattern
      final callback = _externalOnStatus;
      if (callback != null) guard(() => callback('stopped'));
    });
  }

  @override
  Future<void> cancel() async {
    _ensureInitialized();
    await guardFuture<void>(() async {
      await _speechToText.cancel();
      final callback = _externalOnStatus;
      if (callback != null) guard(() => callback('canceled'));
    });
  }

  @override
  bool get isAvailable => _available;

  @override
  bool get isListening =>
      guard<bool>(() => _speechToText.isListening, onError: (e, s) => false) ??
      false;

  @override
  String get lastRecognizedText => _lastRecognizedText;

  @override
  Future<List<GSimpleLocale>> locales() async {
    _ensureInitialized();
    final locales = await guardFuture<List<g_lib.LocaleName>>(
      () async => await _speechToText.locales(),
      onError: (e, s) => <g_lib.LocaleName>[],
    );
    return locales
        .map((l) => GSimpleLocale(localeId: l.localeId, name: l.name))
        .toList();
  }

  @override
  Future<GSimpleLocale?> currentLocale() async {
    _ensureInitialized();
    final systemLocale = await guardFuture<g_lib.LocaleName?>(
      () async => await _speechToText.systemLocale(),
      onError: (e, s) => null,
    );
    if (systemLocale == null) return null;
    return GSimpleLocale(
        localeId: systemLocale.localeId, name: systemLocale.name);
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('GSttImpl is not initialized. Call initialize() first.');
    }
  }
}
