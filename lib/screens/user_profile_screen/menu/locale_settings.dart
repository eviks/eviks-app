import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../providers/locale_provider.dart';

class LocaleSettings extends StatefulWidget {
  const LocaleSettings({Key? key}) : super(key: key);

  @override
  State<LocaleSettings> createState() => _LocaleSettingsState();
}

class _LocaleSettingsState extends State<LocaleSettings> {
  late Locale? _locale;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _locale = Provider.of<LocaleProvider>(context, listen: false).locale;
      setState(() {
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  Future<void> _onChanged(Locale? value) async {
    setState(() {
      _locale = value;
    });
    await Provider.of<LocaleProvider>(context, listen: false)
        .setLocale(_locale ?? const Locale('az'));
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
          AppLocalizations.of(context)!.language,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          RadioListTile<Locale>(
            title: Text(AppLocalizations.of(context)!.azeriLanguage),
            value: const Locale('az'),
            groupValue: _locale,
            onChanged: _onChanged,
          ),
          const SizedBox(
            height: 8.0,
          ),
          RadioListTile<Locale>(
            title: Text(AppLocalizations.of(context)!.russianLanguage),
            value: const Locale('ru'),
            groupValue: _locale,
            onChanged: _onChanged,
          ),
        ],
      ),
    );
  }
}
