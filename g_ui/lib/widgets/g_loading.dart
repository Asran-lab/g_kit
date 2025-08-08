import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:g_common/utils/g_lock.dart' as glock;

/// Global overlay loading widget with lock.
///
/// Usage:
/// final loading = GLoading(child: YourSpinner(), size: const Size(72, 72));
/// await loading.show(context);
/// loading.hide();
class GLoading {
  GLoading({
    required this.child,
    this.size,
    this.lockKey = _defaultLockKey,
    this.barrierColor = const Color(0x99000000),
    this.blurSigma = 3.0,
    this.dismissible = false,
  });

  static const String _defaultLockKey = '__g_loading_global_lock__';

  final Widget child;
  final Size? size;
  final String lockKey;
  final Color barrierColor;
  final double blurSigma;
  final bool dismissible;

  OverlayEntry? _entry;
  bool get isShowing => _entry != null;

  Future<void> show(BuildContext context) async {
    if (isShowing) return;
    await glock.lock(lockKey, () async {
      if (isShowing) return;
      final overlay = Overlay.of(context, rootOverlay: true);
      _entry = OverlayEntry(
        builder: (ctx) => _GLoadingOverlay(
          size: size,
          barrierColor: barrierColor,
          blurSigma: blurSigma,
          dismissible: dismissible,
          onDismiss: hide,
          child: child,
        ),
      );
      overlay.insert(_entry!);
    });
  }

  void hide() {
    _entry?.remove();
    _entry = null;
    glock.unlock(lockKey);
  }
}

class _GLoadingOverlay extends StatelessWidget {
  const _GLoadingOverlay({
    required this.child,
    this.size,
    required this.barrierColor,
    required this.blurSigma,
    required this.dismissible,
    required this.onDismiss,
  });

  final Widget child;
  final Size? size;
  final Color barrierColor;
  final double blurSigma;
  final bool dismissible;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final Widget indicator = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size?.width ?? 96,
          maxHeight: size?.height ?? 96,
        ),
        child: FittedBox(child: child),
      ),
    );

    final overlay = Stack(
      children: [
        // Dim + blur
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(color: barrierColor),
          ),
        ),
        Positioned.fill(child: indicator),
      ],
    );

    if (dismissible) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onDismiss,
          child: overlay,
        ),
      );
    }

    return Material(color: Colors.transparent, child: overlay);
  }
}
