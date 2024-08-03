import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import './edit_post_contacts.dart';
import './step_title.dart';
import '../../models/post.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/styled_input.dart';

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
  bool _isInit = true;

  final _formKey = GlobalKey<FormState>();

  int? _price;
  bool? _haggle = false;
  bool? _installmentOfPayment = false;
  bool? _prepayment = false;
  bool? _municipalServicesIncluded = false;

  late bool _isRent;

  @override
  void didChangeDependencies() {
    postData = Provider.of<Posts>(context).postData;
    if (_isInit) {
      if ((postData?.lastStep ?? -1) >= 7) {
        _price = postData?.price;
        _haggle = postData?.haggle;
        _installmentOfPayment = postData?.installmentOfPayment;
        _prepayment = postData?.prepayment;
        _municipalServicesIncluded = postData?.municipalServicesIncluded;
      }

      _isRent = postData?.dealType != DealType.sale;

      _isInit = false;
    }

    super.didChangeDependencies();
  }

  String _getPriceTitle() {
    switch (postData?.dealType) {
      case DealType.sale:
        return AppLocalizations.of(context)!.price;
      case DealType.rent:
        return AppLocalizations.of(context)!.pricePerMonth;
      case DealType.rentPerDay:
        return AppLocalizations.of(context)!.pricePerDay;
      default:
        return AppLocalizations.of(context)!.price;
    }
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditPostContacts()),
    );
  }

  void _updatePost() {
    Provider.of<Posts>(context, listen: false).setPostData(
      postData?.copyWith(
        price: _price,
        haggle: _haggle,
        installmentOfPayment: _installmentOfPayment,
        prepayment: _prepayment,
        municipalServicesIncluded: _municipalServicesIncluded,
        lastStep: 8,
        step: _goToNextStep ? 9 : 7,
      ),
    );
  }

  void _prevStep() {
    _formKey.currentState!.save();
    _updatePost();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: StepTitle(
          title: AppLocalizations.of(context)!.priceTitle,
        ),
        leading: IconButton(
          onPressed: () {
            _prevStep();
          },
          icon: const Icon(CustomIcons.back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              SizeConfig.safeBlockHorizontal * 7.0,
              8.0,
              SizeConfig.safeBlockHorizontal * 7.0,
              32.0,
            ),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 40.0,
                      child: StyledInput(
                        icon: CustomIcons.money,
                        title: _getPriceTitle(),
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
                          return null;
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
                      },
                    ),
                    Visibility(
                      visible: !_isRent,
                      child: SwitchListTile(
                        value: _installmentOfPayment ?? false,
                        title: Text(
                          AppLocalizations.of(context)!.installmentOfPayment,
                        ),
                        onChanged: (bool? value) {
                          setState(() {
                            _installmentOfPayment = value;
                          });
                        },
                      ),
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
                        },
                      ),
                    ),
                    Visibility(
                      visible: _isRent,
                      child: SwitchListTile(
                        value: _municipalServicesIncluded ?? false,
                        title: Text(
                          AppLocalizations.of(context)!
                              .municipalServicesIncluded,
                        ),
                        onChanged: (bool? value) {
                          setState(() {
                            _municipalServicesIncluded = value;
                          });
                        },
                      ),
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
      ),
      bottomNavigationBar: StyledElevatedButton(
        secondary: true,
        text: AppLocalizations.of(context)!.next,
        onPressed: _continuePressed,
        width: SizeConfig.safeBlockHorizontal * 100.0,
        suffixIcon: CustomIcons.next,
      ),
    );
  }
}
