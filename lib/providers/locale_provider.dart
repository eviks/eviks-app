import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale;

  LocaleProvider(this._locale);

  Locale get locale => _locale;

  Future<void> setLocale(Locale selectedLocale) async {
    if (!AppLocalizations.supportedLocales.contains(selectedLocale)) return;

    _locale = selectedLocale;
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
        'locale',
        locale.toString(),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
