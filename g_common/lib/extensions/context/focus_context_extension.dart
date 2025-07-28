import 'package:flutter/material.dart';

extension FocusContextExtension on BuildContext {
  FocusScopeNode get focusScope => FocusScope.of(this);

  void showKeyboard() => focusScope.requestFocus(FocusNode());

  void hideKeyboard() => focusScope.unfocus();

  bool get hasFocus => focusScope.hasFocus;

  bool get isFirstFocus => focusScope.isFirstFocus;

  bool get hasPrimaryFocus => focusScope.hasPrimaryFocus;

  bool get canRequestFocus => focusScope.canRequestFocus;

  void nextFocus() => focusScope.nextFocus();

  void previousFocus() => focusScope.previousFocus();

  void requestFocus([FocusNode? node]) => focusScope.requestFocus(node);

  void unfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) =>
      focusScope.unfocus(disposition: disposition);

  void setFirstFocus(FocusScopeNode scope) => focusScope.setFirstFocus(scope);

  bool consumeKeyboardToken() => focusScope.consumeKeyboardToken();

  FocusOrder get focusTraversalOrder => FocusTraversalOrder.of(this);

  FocusTraversalPolicy get focusTraversalPolicy => FocusTraversalGroup.of(this);
}
