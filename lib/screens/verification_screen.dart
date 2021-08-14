import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../screens/tabs_screen.dart';
import '../widgets/sized_config.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  static const routeName = '/verification';

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  var _isLoading = false;
  var _activationToken = '';

  void _verify() async {
    if (_activationToken.length < 5) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false)
          .verifyUser(_activationToken);
    } catch (error) {
      rethrow;
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pushNamed(TabsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: SizeConfig.safeBlockHorizontal * 75,
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 40.0,
                  child: Image.asset(
                    "assets/img/illustrations/verification.png",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.verificationTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        AppLocalizations.of(context)!.verificationHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ],
                  ),
                ),
                PinCodeTextField(
                  appContext: context,
                  length: 5,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  enableActiveFill: true,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5.0),
                    activeColor: Theme.of(context).dividerColor,
                    activeFillColor: Theme.of(context).backgroundColor,
                    selectedColor: Theme.of(context).primaryColor,
                    selectedFillColor: Theme.of(context).backgroundColor,
                    inactiveColor: Theme.of(context).dividerColor,
                    inactiveFillColor: Theme.of(context).dividerColor,
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _activationToken = value;
                    });
                  },
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  width: double.infinity,
                  height: 60.0,
                  child: ElevatedButton(
                    onPressed: _verify,
                    child: _isLoading
                        ? SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).backgroundColor,
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context)!.verifyButton,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
