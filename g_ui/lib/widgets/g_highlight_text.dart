import 'package:flutter/material.dart';
import 'package:g_ui/configs/g_text_config.dart';
import 'package:g_ui/widgets/g_text.dart';

class GHighlightText extends StatelessWidget {
  final String text;
  final String seperator;
  final Color? highlightColor, textColor;
  final GTextSize textSize;
  const GHighlightText({
    super.key,
    required this.text,
    this.seperator = "*",
    this.highlightColor,
    this.textColor,
    this.textSize = GTextSize.x14,
  });

  @override
  Widget build(BuildContext context) {
    List<String> textList = text.split(seperator);

    return FittedBox(
      child: GText.rich(
        text,
        span: TextSpan(
          children: List<TextSpan>.generate(
            textList.length,
            (index) => TextSpan(
              text: textList[index],
              style: GTextStyle.get(
                size: textSize,
                weight: index % 2 != 0 ? GTextWeight.bold : GTextWeight.regular,
                color: index % 2 != 0
                    ? (highlightColor ?? Colors.blue)
                    : (textColor ?? Colors.black),
                height: 1.3,
              ),
            ),
          ),
        ),
        align: TextAlign.center,
      ),
    );
  }
}
