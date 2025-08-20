import 'package:flutter/material.dart';
import 'package:g_ui/configs/g_text_config.dart';
import 'package:g_common/extensions/context/context_extension.dart';
import 'package:g_ui/widgets/g_text.dart';

/// [GDialog]
///
/// showDialog 없이도 사용할 수 있는 커스텀 다이얼로그
///
/// 사용 예시:
/// ```dart
/// // 기본 사용
/// showDialog(
///   context: context,
///   builder: (context) => GDialog(
///     title: '제목',
///     content: '내용',
///     actions: [TextButton(onPressed: () => Navigator.pop(context), child: GText('확인', style: context.theme.textTheme.bodyMedium))],
///   ),
/// );
///
/// // 직접 표시 (showDialog 없이)
/// GDialog.show(
///   context: context,
///   title: '제목',
///   content: '내용',
/// );
///
/// // 확인 다이얼로그
/// final result = await GDialog.confirm(
///   context: context,
///   title: '삭제 확인',
///   content: '정말 삭제하시겠습니까?',
/// );
///
/// // 알림 다이얼로그
/// await GDialog.alert(
///   context: context,
///   title: '알림',
///   content: '작업이 완료되었습니다.',
/// );
/// ```
class GDialog extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final String? content;
  final Widget? contentWidget;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? actionsPadding;
  final double? width;
  final double? height;
  final Color? backgroundColor, titleColor, contentColor;
  final ShapeBorder? shape;
  final bool scrollable;
  final bool barrierDismissible;
  final Color? barrierColor;

  const GDialog({
    super.key,
    this.title,
    this.titleWidget,
    this.content,
    this.contentWidget,
    this.actions,
    this.contentPadding,
    this.titlePadding,
    this.actionsPadding,
    this.width,
    this.height,
    this.backgroundColor,
    this.titleColor,
    this.contentColor,
    this.shape,
    this.scrollable = false,
    this.barrierDismissible = true,
    this.barrierColor,
  })  : assert(
          (title != null) ^ (titleWidget != null) ||
              (title == null && titleWidget == null),
          'title과 titleWidget 중 하나만 사용하거나 둘 다 null이어야 합니다.',
        ),
        assert(
          (content != null) ^ (contentWidget != null) ||
              (content == null && contentWidget == null),
          'content와 contentWidget 중 하나만 사용하거나 둘 다 null이어야 합니다.',
        );

  /// 다이얼로그를 직접 표시하는 정적 메서드
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    Widget? titleWidget,
    String? content,
    Widget? contentWidget,
    List<Widget>? actions,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? titlePadding,
    EdgeInsetsGeometry? actionsPadding,
    double? width,
    double? height,
    Color? backgroundColor,
    Color? titleColor,
    Color? contentColor,
    ShapeBorder? shape,
    bool scrollable = false,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => GDialog(
        title: title,
        titleWidget: titleWidget,
        content: content,
        contentWidget: contentWidget,
        actions: actions,
        contentPadding: contentPadding,
        titlePadding: titlePadding,
        actionsPadding: actionsPadding,
        width: width,
        height: height,
        backgroundColor: backgroundColor,
        titleColor: titleColor,
        contentColor: contentColor,
        shape: shape,
        scrollable: scrollable,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
      ),
    );
  }

  /// 확인 다이얼로그를 표시하는 정적 메서드
  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = '확인',
    String cancelText = '취소',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    Color? cancelColor,
    Color? titleColor,
    Color? contentColor,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => GDialog(
        title: title,
        content: content,
        titleColor: titleColor,
        contentColor: contentColor,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        actions: [
          TextButton(
            onPressed: onCancel ?? () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: cancelColor ??
                  context.theme.textTheme.bodyMedium?.color
                      ?.withValues(alpha: 0.6),
            ),
            child: GText(cancelText, style: context.theme.textTheme.bodyMedium),
          ),
          TextButton(
            onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: confirmColor ?? context.primary,
            ),
            child:
                GText(confirmText, style: context.theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  /// 알림 다이얼로그를 표시하는 정적 메서드
  static Future<void> alert({
    required BuildContext context,
    required String title,
    required String content,
    String buttonText = '확인',
    VoidCallback? onPressed,
    Color? buttonColor,
    Color? titleColor,
    Color? contentColor,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => GDialog(
        title: title,
        content: content,
        titleColor: titleColor,
        contentColor: contentColor,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        actions: [
          TextButton(
            onPressed: onPressed ?? () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor:
                  buttonColor ?? Theme.of(context).colorScheme.primary,
            ),
            child: GText(buttonText, style: context.theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Material을 제공하여 TextTheme을 적용
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: width,
          height: height,
          constraints: BoxConstraints(
            minWidth: context.width * 0.5,
            maxWidth: context.width * 0.9,
            maxHeight: context.height * 0.8,
          ),
          child: Dialog(
            backgroundColor:
                backgroundColor ?? context.theme.dialogTheme.backgroundColor,
            shape: shape ?? context.theme.dialogTheme.shape,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title Section
                if (title != null || titleWidget != null)
                  Padding(
                    padding: titlePadding ??
                        const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: titleWidget ??
                        GText(
                          title!,
                          color: titleColor ??
                              context.theme.dialogTheme.titleTextStyle?.color,
                          style: GTextStyle.get(
                            size: GTextSize.x18,
                            weight: GTextWeight.bold,
                          ),
                        ),
                  ),

                // Content Section
                if (content != null || contentWidget != null)
                  Flexible(
                    child: SingleChildScrollView(
                      physics: scrollable
                          ? null
                          : const NeverScrollableScrollPhysics(),
                      child: Padding(
                        padding: contentPadding ??
                            const EdgeInsets.fromLTRB(24, 20, 24, 24),
                        child: contentWidget ??
                            GText(
                              content!,
                              color: contentColor ??
                                  context.theme.dialogTheme.contentTextStyle
                                      ?.color,
                              style:
                                  context.theme.dialogTheme.contentTextStyle ??
                                      GTextStyle.get(
                                        size: GTextSize.x14,
                                        weight: GTextWeight.regular,
                                      ),
                            ),
                      ),
                    ),
                  ),

                // Actions Section
                if (actions != null && actions!.isNotEmpty)
                  Padding(
                    padding:
                        actionsPadding ?? const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: OverflowBar(
                      alignment: MainAxisAlignment.end,
                      spacing: 8,
                      children: actions!,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 간단한 확인 다이얼로그
class GConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final Color? cancelColor;
  final Color? titleColor;
  final Color? contentColor;
  final bool barrierDismissible;
  final Color? barrierColor;

  const GConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = '확인',
    this.cancelText = '취소',
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.cancelColor,
    this.titleColor,
    this.contentColor,
    this.barrierDismissible = true,
    this.barrierColor,
  });

  /// 확인 다이얼로그를 직접 표시
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = '확인',
    String cancelText = '취소',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    Color? cancelColor,
    Color? titleColor,
    Color? contentColor,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => GConfirmDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmColor: confirmColor,
        cancelColor: cancelColor,
        titleColor: titleColor,
        contentColor: contentColor,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GDialog(
      title: title,
      content: content,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            foregroundColor: cancelColor ??
                context.theme.textTheme.bodyMedium?.color
                    ?.withValues(alpha: 0.6),
          ),
          child: GText(
            cancelText,
            color: cancelColor ??
                context.theme.textTheme.bodyMedium?.color
                    ?.withValues(alpha: 0.6),
            style: context.theme.textTheme.bodyMedium,
          ),
        ),
        TextButton(
          onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: confirmColor ?? context.primary,
          ),
          child: GText(
            confirmText,
            color: confirmColor ?? context.primary,
            style: context.theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

/// 간단한 알림 다이얼로그
class GAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final Color? titleColor;
  final Color? contentColor;
  final bool barrierDismissible;
  final Color? barrierColor;

  const GAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.buttonText = '확인',
    this.onPressed,
    this.buttonColor,
    this.titleColor,
    this.contentColor,
    this.barrierDismissible = true,
    this.barrierColor,
  });

  /// 알림 다이얼로그를 직접 표시
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    String buttonText = '확인',
    VoidCallback? onPressed,
    Color? buttonColor,
    Color? titleColor,
    Color? contentColor,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => GAlertDialog(
        title: title,
        content: content,
        buttonText: buttonText,
        onPressed: onPressed,
        buttonColor: buttonColor,
        titleColor: titleColor,
        contentColor: contentColor,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GDialog(
      title: title,
      content: content,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      titleColor: titleColor,
      contentColor: contentColor,
      actions: [
        TextButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: buttonColor ?? context.primary,
          ),
          child: GText(
            buttonText,
            color: buttonColor ?? context.primary,
            style: context.theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
