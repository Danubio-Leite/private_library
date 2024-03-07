// AppLocalizationsDelegate.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'portuguese.dart';
import 'english.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'pt'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
        locale.languageCode == 'pt' ? Portuguese() : English());
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

abstract class AppLocalizations {
  static const AppLocalizationsDelegate delegate = AppLocalizationsDelegate();
}
