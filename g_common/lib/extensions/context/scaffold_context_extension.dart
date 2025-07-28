import 'package:flutter/material.dart';

extension ScaffoldContextExtension on BuildContext {
  ScaffoldState get scaffoldState => Scaffold.of(this);
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 2),
    bool showCloseIcon = true,
  }) {
    return scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: duration,
        showCloseIcon: showCloseIcon,
      ),
    );
  }

  void removeSnackBar({
    SnackBarClosedReason reason = SnackBarClosedReason.remove,
  }) =>
      scaffoldMessenger.removeCurrentSnackBar(reason: reason);

  void hideSnackBar({
    SnackBarClosedReason reason = SnackBarClosedReason.hide,
  }) =>
      scaffoldMessenger.hideCurrentSnackBar(reason: reason);

  void showBottomSheet(
    WidgetBuilder builder, {
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
  }) =>
      scaffoldState.showBottomSheet(
        builder,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
      );

  Future<void> showFullDialog(
    Widget child, {
    bool barrierDismissible = false,
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 200),
    bool useRootNavigator = true,
  }) async {
    await showGeneralDialog(
      context: this,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      useRootNavigator: useRootNavigator,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) =>
          child,
    );
  }

  /// 기본 다이얼로그 표시
  // Future<T?> _showGDialog<T>(
  //   Widget dialog, {
  //   bool barrierDismissible = true,
  //   Color? barrierColor,
  //   String? barrierLabel,
  //   bool useRootNavigator = true,
  // }) {
  //   return showDialog<T>(
  //     context: this,
  //     barrierDismissible: barrierDismissible,
  //     barrierColor: barrierColor,
  //     barrierLabel: barrierLabel,
  //     useRootNavigator: useRootNavigator,
  //     builder: (context) => dialog,
  //   );
  // }

  // /// 알림 다이얼로그 표시
  // Future<void> showAlertDialog({
  //   required String title,
  //   required String content,
  //   String buttonText = '확인',
  //   Color? buttonColor,
  //   bool barrierDismissible = true,
  // }) {
  //   return _showGDialog<void>(
  //     GAlertDialog(
  //       title: title,
  //       content: content,
  //       buttonText: buttonText,
  //       buttonColor: buttonColor,
  //     ),
  //     barrierDismissible: barrierDismissible,
  //   );
  // }

  // /// 확인 다이얼로그 표시
  // Future<bool?> showConfirmDialog({
  //   required String title,
  //   required String content,
  //   String confirmText = '확인',
  //   String cancelText = '취소',
  //   Color? confirmColor,
  //   Color? cancelColor,
  //   bool barrierDismissible = true,
  // }) {
  //   return _showGDialog<bool>(
  //     GConfirmDialog(
  //       title: title,
  //       content: content,
  //       confirmText: confirmText,
  //       cancelText: cancelText,
  //       confirmColor: confirmColor,
  //       cancelColor: cancelColor,
  //     ),
  //     barrierDismissible: barrierDismissible,
  //   );
  // }
  //  /// 커스텀 다이얼로그 표시 (기본 틀 제공)
  // Future<T?> showCustomDialog<T>({
  //   String? title,
  //   Widget? titleWidget,
  //   String? content,
  //   Widget? contentWidget,
  //   List<Widget>? actions,
  //   EdgeInsetsGeometry? contentPadding,
  //   EdgeInsetsGeometry? titlePadding,
  //   EdgeInsetsGeometry? actionsPadding,
  //   double? width,
  //   double? height,
  //   Color? backgroundColor,
  //   ShapeBorder? shape,
  //   bool scrollable = false,
  //   bool barrierDismissible = true,
  // }) {
  //   return _showGDialog<T>(
  //     GDialog(
  //       title: title,
  //       titleWidget: titleWidget,
  //       content: content,
  //       contentWidget: contentWidget,
  //       actions: actions,
  //       contentPadding: contentPadding,
  //       titlePadding: titlePadding,
  //       actionsPadding: actionsPadding,
  //       width: width,
  //       height: height,
  //       backgroundColor: backgroundColor,
  //       shape: shape,
  //       scrollable: scrollable,
  //     ),
  //     barrierDismissible: barrierDismissible,
  //   );
  // }

  /// Drawer 관련

  bool get hasDrawer => scaffoldState.hasDrawer;

  bool get hasEndDrawer => scaffoldState.hasEndDrawer;

  void openDrawer() => scaffoldState.openDrawer();

  void openEndDrawer() => scaffoldState.openEndDrawer();

  void closeDrawer() => scaffoldState.closeDrawer();

  void closeEndDrawer() => scaffoldState.closeEndDrawer();
}
