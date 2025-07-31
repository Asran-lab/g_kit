import 'package:flutter/material.dart';
import 'package:g_common/utils/g_color.dart';
import 'package:g_ui/configs/g_color_config.dart';
import 'package:g_ui/configs/g_text_config.dart';

InputDecorationTheme gInputTheme(
  GColorConfig config, {
  bool isFilled = false,
  bool isDense = false,
  Size? contentPadding,
}) {
  return InputDecorationTheme(
    filled: isFilled,
    isDense: isDense,
    contentPadding: EdgeInsets.symmetric(
      horizontal: contentPadding?.width ?? 16,
      vertical: contentPadding?.height ?? 12,
    ),
    hintStyle: GTextStyle.get(
      size: GTextSize.x12,
      weight: GTextWeight.thin,
      color: toColor(config.error).withValues(alpha: 0.5),
    ),
    border: _border(config),
    focusedBorder: _border(config, isFocused: true),
    errorBorder: _border(config, isError: true),
    disabledBorder: _border(config, isDisabled: true),
  );
}

OutlineInputBorder _border(
  GColorConfig config, {
  bool isFocused = false,
  bool isError = false,
  bool isDisabled = false,
  double? radius,
}) {
  final borderColor = toColor(config.outline);
  final focusedBorderColor = toColor(config.primary);
  final errorBorderColor = toColor(config.error);
  final disabledBorderColor = toColor(config.outline);

  Color color = borderColor;
  if (isFocused) {
    color = focusedBorderColor;
  }
  if (isError) {
    color = errorBorderColor;
  }
  if (isDisabled) {
    color = disabledBorderColor;
  }

  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius ?? 8),
    borderSide: BorderSide(
      color: color,
      width: 1,
    ),
  );
}
