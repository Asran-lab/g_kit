import 'package:flutter/material.dart';

extension LocaleContextExtension on BuildContext {
  Locale get locale => Localizations.localeOf(this);

  String get languageCode => locale.languageCode;

  String? get countryCode => locale.countryCode;

  MaterialLocalizations get materialLocalizations =>
      MaterialLocalizations.of(this);

  WidgetsLocalizations get widgetsLocalizations =>
      WidgetsLocalizations.of(this);
}
