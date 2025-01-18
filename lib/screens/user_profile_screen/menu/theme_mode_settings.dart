import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_preferences.dart';

class ThemeModeSettings extends StatefulWidget {
  const ThemeModeSettings({Key? key}) : super(key: key);

  @override
  State<ThemeModeSettings> createState() => _ThemeModeSettingsState();
}

class _ThemeModeSettingsState extends State<ThemeModeSettings> {
  late ThemeMode? _themeMode;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _themeMode =
          Provider.of<ThemePreferences>(context, listen: false).themeMode;
      setState(() {
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  Future<void> _onChanged(ThemeMode? value) async {
    setState(() {
      _themeMode = value;
    });
    await Provider.of<ThemePreferences>(context, listen: false)
        .setThemePreferences(_themeMode ?? ThemeMode.system);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(LucideIcons.arrowLeft),
              )
            : null,
        title: Text(
          AppLocalizations.of(context)!.theme,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: Text(AppLocalizations.of(context)!.lightTheme),
            value: ThemeMode.light,
            groupValue: _themeMode,
            onChanged: _onChanged,
          ),
          const SizedBox(
            height: 8.0,
          ),
          RadioListTile<ThemeMode>(
            title: Text(AppLocalizations.of(context)!.darkTheme),
            value: ThemeMode.dark,
            groupValue: _themeMode,
            onChanged: _onChanged,
          ),
          const SizedBox(
            height: 8.0,
          ),
          RadioListTile<ThemeMode>(
            title: Text(AppLocalizations.of(context)!.systemTheme),
            value: ThemeMode.system,
            groupValue: _themeMode,
            onChanged: _onChanged,
          ),
        ],
      ),
    );
  }
}
