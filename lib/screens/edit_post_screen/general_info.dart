import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flow_builder/flow_builder.dart';

import '../../models/post.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/toggle_field.dart';
import './step_title.dart';

class GeneralInfo extends StatefulWidget {
  const GeneralInfo({
    Key? key,
  }) : super(key: key);

  @override
  _GeneralInfoState createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  final _formKey = GlobalKey<FormState>();

  UserType? _userType;
  EstateType? _estateType;
  ApartmentType? _apartmentType;
  DealType? _dealType;
  late bool _isApartment;

  @override
  void initState() {
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

    context.flow<Post>().update((post) {
      return post.copyWith(
        userType: _userType,
        estateType: _estateType,
        apartmentType: _apartmentType,
        dealType: _dealType,
        step: 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StepTitle(
                  title: AppLocalizations.of(context)!.generalInfo,
                  icon: CustomIcons.information,
                ),
                ToggleFormField<UserType>(
                  title: AppLocalizations.of(context)!.userTypeTitle,
                  values: UserType.values,
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
                    getDescription: estateTypeDescription,
                    validator: (value) {
                      if (value == null) {
                        return AppLocalizations.of(context)!.fieldIsRequired;
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
                    getDescription: apartmentTypeDescription,
                    validator: (value) {
                      if (_estateType == EstateType.apartment &&
                          value == null) {
                        return AppLocalizations.of(context)!.fieldIsRequired;
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
                  height: 16.0,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  width: SizeConfig.safeBlockHorizontal * 50,
                  height: 60.0,
                  child: ElevatedButton(
                    onPressed: _continuePressed,
                    child: Text(
                      AppLocalizations.of(context)!.next,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
