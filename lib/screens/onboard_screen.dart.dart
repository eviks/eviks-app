import 'package:eviks_mobile/constants.dart';
import 'package:eviks_mobile/icons.dart';
import 'package:eviks_mobile/screens/tabs_screen.dart';
import 'package:eviks_mobile/widgets/sized_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Future<void> onIntroEnd(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'launchVersion',
      appLaunchVersion.toString(),
    );

    if (!context.mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => TabsScreen()),
    );
  }

  Widget _buildImage(String asset) {
    return Image.asset(
      asset,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return IntroductionScreen(
      key: introKey,
      allowImplicitScrolling: true,
      showSkipButton: true,
      back: const Icon(CustomIcons.back),
      skip: Text(
        AppLocalizations.of(context)!.onBoardSkip,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      next: const Icon(CustomIcons.next),
      done: Text(
        AppLocalizations.of(context)!.onBoardDone,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      onDone: () => onIntroEnd(context),
      onSkip: () => onIntroEnd(context),
      pages: [
        PageViewModel(
          title: AppLocalizations.of(context)!.onBoardWelcomeTitle,
          body: AppLocalizations.of(context)!.onBoardWelcomeSubtitle,
          image: _buildImage('assets/img/illustrations/post_confirm.png'),
          decoration: const PageDecoration(
            bodyAlignment: Alignment.center,
            imagePadding: EdgeInsets.only(top: 50.0),
          ),
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.onBoardSubscriptionsTitle,
          body: AppLocalizations.of(context)!.onBoardSubscriptionsSubtitle,
          image: _buildImage('assets/img/illustrations/subscriptions.png'),
          decoration: const PageDecoration(
            bodyAlignment: Alignment.center,
            imagePadding: EdgeInsets.only(top: 50.0),
          ),
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.onBoardMapTitle,
          body: AppLocalizations.of(context)!.onBoardMapSubtitle,
          image: _buildImage('assets/img/illustrations/map.png'),
          decoration: const PageDecoration(
            bodyAlignment: Alignment.center,
            imagePadding: EdgeInsets.only(top: 50.0),
          ),
        ),
      ],
    );
  }
}
