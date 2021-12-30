import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                icon: const Icon(CustomIcons.back),
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
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: _themeMode,
            onChanged: _onChanged,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: _themeMode,
            onChanged: _onChanged,
          ),
          RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: _onChanged),
        ],
      ),
    );
  }
}
