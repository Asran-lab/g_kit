import 'package:flutter/material.dart';
import 'package:g_common/utils/g_color.dart';
import 'package:g_ui/configs/g_color_config.dart';

DividerThemeData gDividerTheme(
  GColorConfig config,
  Brightness brightness,
) {
  return DividerThemeData(
    color: toColor(config.outline).withValues(alpha: 0.5),
    space: 14,
    thickness: 1,
    indent: 1,
    endIndent: 1,
  );
}
