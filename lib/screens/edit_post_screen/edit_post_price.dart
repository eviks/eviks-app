import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/styled_input.dart';
import './step_title.dart';

class EditPostPrice extends StatefulWidget {
  const EditPostPrice({
    Key? key,
  }) : super(key: key);

  @override
  _EditPostPriceState createState() => _EditPostPriceState();
}

class _EditPostPriceState extends State<EditPostPrice> {
  late Post? postData;
  bool _goToNextStep = false;

  final _formKey = GlobalKey<FormState>();

  int? _price;
  bool? _haggle = false;
  bool? _installmentOfPayment = false;
  bool? _prepayment = false;
  bool? _municipalServicesIncluded = false;

  late bool _isRent;

  @override
  void initState() {
    postData = Provider.of<Posts>(context, listen: false).postData;

    if ((postData?.lastStep ?? -1) >= 6) {
      _price = postData?.price;
      _haggle = postData?.haggle;
      _installmentOfPayment = postData?.installmentOfPayment;
      _prepayment = postData?.prepayment;
      _municipalServicesIncluded = postData?.municipalServicesIncluded;
    }

    _isRent = postData?.dealType != DealType.sale;
    super.initState();
  }

  void _continuePressed() {
    if (_formKey.currentState == null) {
      return;
    }

    _formKey.currentState!.save();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _goToNextStep = true;
    _updatePost();
  }

  void _updatePost({bool notify = true}) {
    Provider.of<Posts>(context, listen: false).updatePost(
        postData?.copyWith(
          price: _price,
          haggle: _haggle,
          installmentOfPayment: _installmentOfPayment,
          prepayment: _prepayment,
          municipalServicesIncluded: _municipalServicesIncluded,
          lastStep: 6,
          step: _goToNextStep ? 7 : 5,
        ),
        notify: notify);
  }

  @override
  void deactivate() {
    if (!_goToNextStep) {
      _formKey.currentState?.save();
      _updatePost(notify: false);
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 15.0,
                8.0, SizeConfig.safeBlockHorizontal * 15.0, 32.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StepTitle(
                      title: AppLocalizations.of(context)!.priceTitle,
                      icon: CustomIcons.wallet,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 40.0,
                      child: StyledInput(
                        icon: CustomIcons.money,
                        title: AppLocalizations.of(context)!.price,
                        initialValue: _price != 0 ? _price?.toString() : null,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .errorRequiredField;
                          }
                        },
                        onSaved: (value) {
                          _price =
                              value?.isEmpty ?? true ? 0 : int.parse(value!);
                        },
                      ),
                    ),
                    SwitchListTile(
                        value: _haggle ?? false,
                        title: Text(AppLocalizations.of(context)!.haggle),
                        onChanged: (bool? value) {
                          setState(() {
                            _haggle = value;
                          });
                        }),
                    Visibility(
                      visible: !_isRent,
                      child: SwitchListTile(
                          value: _installmentOfPayment ?? false,
                          title: Text(AppLocalizations.of(context)!
                              .installmentOfPayment),
                          onChanged: (bool? value) {
                            setState(() {
                              _installmentOfPayment = value;
                            });
                          }),
                    ),
                    Visibility(
                      visible: _isRent,
                      child: SwitchListTile(
                          value: _prepayment ?? false,
                          title: Text(AppLocalizations.of(context)!.prepayment),
                          onChanged: (bool? value) {
                            setState(() {
                              _prepayment = value;
                            });
                          }),
                    ),
                    Visibility(
                      visible: _isRent,
                      child: SwitchListTile(
                          value: _municipalServicesIncluded ?? false,
                          title: Text(AppLocalizations.of(context)!
                              .municipalServicesIncluded),
                          onChanged: (bool? value) {
                            setState(() {
                              _municipalServicesIncluded = value;
                            });
                          }),
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  blurRadius: 8.0,
                  offset: const Offset(10.0, 10.0),
                )
              ],
            ),
            child: StyledElevatedButton(
              secondary: true,
              text: AppLocalizations.of(context)!.next,
              onPressed: _continuePressed,
              width: SizeConfig.safeBlockHorizontal * 100.0,
              suffixIcon: CustomIcons.next,
            ),
          ),
        ),
      ],
    );
  }
}
