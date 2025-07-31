import 'package:flutter/material.dart';
import 'package:g_ui/configs/g_text_config.dart';

/// [GText] 텍스트 위젯
///
/// 사용 예시:
/// ```dart
/// GText('Hello, World!')
/// GText.rich(TextSpan(text: 'Hello, World!', children: [
///   TextSpan(text: 'Hello, World!', style: GTextStyle.get(size: GTextSize.x14, weight: GTextWeight.regular, color: Colors.black)),
/// ]))
/// ```
///
/// [GText] 위젯은 [Text] 위젯을 래핑하여 사용합니다.
class GText extends StatelessWidget {
  final GTextType type;
  final InlineSpan? span;
  final bool isRich;

  final String? text;
  final Color? color;
  final GTextSize size;
  final GTextWeight bold;
  final String ifNull;
  final int? maxLines;
  final TextStyle? style;
  final TextAlign? align;
  final TextOverflow? overflow;
  final double? minFontSize;
  final double? steps;

  const GText(
    this.text, {
    super.key,
    this.color,
    this.size = GTextSize.x14,
    this.bold = GTextWeight.regular,
    this.ifNull = '',
    this.maxLines = 1,
    this.style,
    this.overflow = TextOverflow.ellipsis,
    this.align = TextAlign.start,
    this.minFontSize,
    this.steps,
  }) : type = GTextType.normal,
       isRich = false,
       span = null;

  const GText.rich(
    this.text, {
    this.span,
    super.key,
    this.align,
    this.overflow,
    this.maxLines,
  }) : type = GTextType.rich,
       isRich = true,
       size = GTextSize.x14,
       bold = GTextWeight.regular,
       color = null,
       style = null,
       ifNull = '',
       minFontSize = null,
       steps = null;

  const GText.auto(
    this.text, {
    super.key,
    this.color,
    this.size = GTextSize.x14,
    this.bold = GTextWeight.regular,
    this.ifNull = '',
    this.maxLines = 1,
    this.align = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.minFontSize = 10,
    this.steps = 0.5,
  }) : type = GTextType.auto,
       isRich = false,
       span = null,
       style = null;

  @override
  Widget build(BuildContext context) {
    final baseStyle = GTextStyle.get(size: size, weight: bold, color: color);

    return switch (type) {
      GTextType.normal => Text(
        text ?? ifNull,
        style: baseStyle.merge(style),
        maxLines: maxLines,
        overflow: overflow,
        textAlign: align,
      ),
      GTextType.rich => Text.rich(
        span!,
        textAlign: align,
        overflow: overflow,
        maxLines: maxLines,
      ),
      GTextType.auto => LayoutBuilder(
        builder: (context, constraints) {
          double currentFontSize = baseStyle.fontSize!;
          TextPainter painter;

          while (currentFontSize >= minFontSize!) {
            final testStyle = baseStyle.copyWith(fontSize: currentFontSize);
            painter = TextPainter(
              text: TextSpan(text: text ?? ifNull, style: testStyle),
              maxLines: maxLines,
              textDirection: TextDirection.ltr,
            )..layout(maxWidth: constraints.maxWidth);

            if (!painter.didExceedMaxLines) {
              return Text(
                text ?? ifNull,
                style: testStyle,
                textAlign: align,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              );
            }

            currentFontSize -= steps!;
          }

          return Text(
            text ?? ifNull,
            style: baseStyle.copyWith(fontSize: minFontSize),
            textAlign: align,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
    };
  }
}
