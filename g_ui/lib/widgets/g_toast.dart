import 'package:flutter/material.dart';
import 'package:g_common/extensions/context/theme_context_extension.dart';
import 'package:g_ui/g_ui.dart';

class GToast {
  static void show(BuildContext context, String message,
      {Color? backgroundColor, Color? textColor}) {
    final overlay = Overlay.of(context, rootOverlay: true);
    final entry = OverlayEntry(
      builder: (ctx) {
        final viewInsets = MediaQuery.of(ctx).viewInsets.bottom;
        final bottom = (viewInsets > 0 ? viewInsets : 0) + 100.0;
        return Positioned(
          left: 16,
          right: 16,
          bottom: bottom,
          child: IgnorePointer(
            ignoring: true,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color:
                    backgroundColor ?? context.surface.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: GText(
                  message,
                  align: TextAlign.start,
                  size: GTextSize.x12,
                  color: textColor ?? context.onSurface,
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 3000), () {
      entry.remove();
    });
  }
}
