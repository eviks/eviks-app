import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/post.dart';
import '../../providers/theme_preferences.dart';
import '../../widgets/sized_config.dart';

class PostDetailUser extends StatelessWidget {
  final Post post;

  const PostDetailUser({
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final bool isDarkMode =
        Provider.of<ThemePreferences>(context, listen: false).themeMode ==
            ThemeMode.dark;
    final dateFormatter = DateFormat(
        'dd MMMM yyyy HH:mm', Localizations.localeOf(context).languageCode);
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 15.0),
      width: SizeConfig.safeBlockHorizontal * 100,
      decoration: BoxDecoration(
        color: isDarkMode
            ? lighten(Theme.of(context).primaryColor, 0.2)
            : lighten(Theme.of(context).primaryColor, 0.35),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            8.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              post.username,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Theme.of(context).backgroundColor : null,
              ),
            ),
          ),
          Text(
            '${AppLocalizations.of(context)!.postAuthor}, ${userTypeDescription(post.userType, context).toLowerCase()}',
            style: TextStyle(
              color: isDarkMode ? Theme.of(context).backgroundColor : null,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            dateFormatter.format(post.updatedAt),
            style: TextStyle(
              color: isDarkMode ? Theme.of(context).backgroundColor : null,
            ),
          ),
        ],
      ),
    );
  }
}
