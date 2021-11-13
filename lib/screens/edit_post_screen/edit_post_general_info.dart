import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/toggle_field.dart';
import './step_title.dart';

class EditPostGeneralInfo extends StatefulWidget {
  const EditPostGeneralInfo({
    Key? key,
  }) : super(key: key);

  @override
  _EditPostGeneralInfoState createState() => _EditPostGeneralInfoState();
}

class _EditPostGeneralInfoState extends State<EditPostGeneralInfo> {
  late Post? postData;

  final _formKey = GlobalKey<FormState>();

  UserType? _userType;
  EstateType? _estateType;
  ApartmentType? _apartmentType;
  DealType? _dealType;
  late bool _isApartment;

  @override
  void initState() {
    postData = Provider.of<Posts>(context, listen: false).postData;

    if ((postData?.lastStep ?? -1) >= 0) {
      _userType = postData?.userType;
      _estateType = postData?.estateType;
      _apartmentType = postData?.apartmentType;
      _dealType = postData?.dealType;
    }

    _isApartment = _estateType == EstateType.apartment;
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

    Provider.of<Posts>(context, listen: false).updatePost(postData?.copyWith(
      userType: _userType,
      estateType: _estateType,
      apartmentType: _apartmentType,
      dealType: _dealType,
      lastStep: 0,
      step: 1,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockHorizontal * 20.0,
                vertical: 32.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StepTitle(
                      title: AppLocalizations.of(context)!.generalInfo,
                      icon: CustomIcons.information,
                    ),
                    ToggleFormField<UserType>(
                      title: AppLocalizations.of(context)!.userTypeTitle,
                      values: UserType.values,
                      initialValue: _userType,
                      getDescription: userTypeDescription,
                      validator: (value) {
                        if (value == null) {
                          return AppLocalizations.of(context)!.fieldIsRequired;
                        }
                      },
                      onSaved: (value) {
                        _userType = value;
                      },
                    ),
                    ToggleFormField<EstateType>(
                        title: AppLocalizations.of(context)!.estateTypeTitle,
                        values: EstateType.values,
                        initialValue: _estateType,
                        getDescription: estateTypeDescription,
                        validator: (value) {
                          if (value == null) {
                            return AppLocalizations.of(context)!
                                .fieldIsRequired;
                          }
                        },
                        onSaved: (value) {
                          _estateType = value;
                        },
                        onPressed: (EstateType value) {
                          setState(() {
                            _isApartment = value == EstateType.apartment;
                          });
                        }),
                    Visibility(
                      visible: _isApartment,
                      child: ToggleFormField<ApartmentType>(
                        title: AppLocalizations.of(context)!.apartmentTypeTitle,
                        values: ApartmentType.values,
                        initialValue: _apartmentType,
                        getDescription: apartmentTypeDescription,
                        validator: (value) {
                          if (_estateType == EstateType.apartment &&
                              value == null) {
                            return AppLocalizations.of(context)!
                                .fieldIsRequired;
                          }
                        },
                        onSaved: (value) {
                          _apartmentType = value;
                        },
                      ),
                    ),
                    ToggleFormField<DealType>(
                      title: AppLocalizations.of(context)!.dealTypeTitle,
                      values: DealType.values,
                      initialValue: _dealType,
                      getDescription: dealTypeDescription,
                      validator: (value) {
                        if (value == null) {
                          return AppLocalizations.of(context)!.fieldIsRequired;
                        }
                      },
                      onSaved: (value) {
                        _dealType = value;
                      },
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
