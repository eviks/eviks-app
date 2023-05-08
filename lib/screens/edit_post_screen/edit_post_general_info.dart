import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import './edit_post_map.dart';
import './step_title.dart';
import '../../models/post.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/toggle_field.dart';

class EditPostGeneralInfo extends StatefulWidget {
  const EditPostGeneralInfo({
    Key? key,
  }) : super(key: key);

  @override
  _EditPostGeneralInfoState createState() => _EditPostGeneralInfoState();
}

class _EditPostGeneralInfoState extends State<EditPostGeneralInfo> {
  late Post? postData;
  bool _goToNextStep = false;
  bool _isInit = true;

  final _formKey = GlobalKey<FormState>();

  UserType? _userType;
  EstateType? _estateType;
  ApartmentType? _apartmentType;
  DealType? _dealType;
  late bool _isApartment;

  @override
  void didChangeDependencies() {
    postData = Provider.of<Posts>(context).postData;
    if (_isInit) {
      if ((postData?.lastStep ?? -1) >= 0) {
        _userType = postData?.userType;
        _estateType = postData?.estateType;
        _apartmentType = postData?.apartmentType;
        _dealType = postData?.dealType;
      }

      _isApartment = _estateType == EstateType.apartment;

      _isInit = false;
    }

    super.didChangeDependencies();
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
      MaterialPageRoute(builder: (context) => const EditPostMap()),
    );
  }

  void _updatePost() {
    Provider.of<Posts>(context, listen: false).setPostData(
      postData?.copyWith(
        userType: _userType,
        estateType: _estateType,
        apartmentType: _apartmentType,
        dealType: _dealType,
        lastStep: 0,
        step: _goToNextStep ? 1 : -1,
      ),
    );
  }

  void _prevStep() {
    _formKey.currentState!.save();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: StepTitle(
          title: AppLocalizations.of(context)!.generalInfo,
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
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 8.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleFormField<UserType>(
                      title: AppLocalizations.of(context)!.userTypeTitle,
                      values: UserType.values,
                      initialValue: _userType,
                      getDescription: userTypeDescription,
                      validator: (value) {
                        if (value == null) {
                          return AppLocalizations.of(context)!.fieldIsRequired;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userType = value;
                      },
                      icons: const [
                        CustomIcons.user,
                        CustomIcons.agent,
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleFormField<EstateType>(
                      title: AppLocalizations.of(context)!.estateTypeTitle,
                      values: EstateType.values,
                      initialValue: _estateType,
                      getDescription: estateTypeDescription,
                      validator: (value) {
                        if (value == null) {
                          return AppLocalizations.of(context)!.fieldIsRequired;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _estateType = value;
                      },
                      onPressed: (EstateType? value) {
                        setState(() {
                          _isApartment = value == EstateType.apartment;
                        });
                      },
                      icons: const [
                        CustomIcons.apartment,
                        CustomIcons.house,
                      ],
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _isApartment ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Visibility(
                      visible: _isApartment,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ToggleFormField<ApartmentType>(
                          title:
                              AppLocalizations.of(context)!.apartmentTypeTitle,
                          values: ApartmentType.values,
                          initialValue: _apartmentType,
                          getDescription: apartmentTypeDescription,
                          validator: (value) {
                            if (_estateType == EstateType.apartment &&
                                value == null) {
                              return AppLocalizations.of(context)!
                                  .fieldIsRequired;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _apartmentType = value;
                          },
                          icons: const [
                            CustomIcons.newbuilding,
                            CustomIcons.secondarybuilding,
                          ],
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleFormField<DealType>(
                      title: AppLocalizations.of(context)!.dealTypeTitle,
                      values: DealType.values,
                      initialValue: _dealType,
                      getDescription: dealTypeDescription,
                      validator: (value) {
                        if (value == null) {
                          return AppLocalizations.of(context)!.fieldIsRequired;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _dealType = value;
                      },
                      icons: const [
                        CustomIcons.sale,
                        CustomIcons.rent,
                        CustomIcons.rentperday,
                      ],
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
