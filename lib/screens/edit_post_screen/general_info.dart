import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flow_builder/flow_builder.dart';

import '../../models/post.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/toggle_field.dart';

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

  void _continuePressed() {
    context.flow<Post>().update(
          (post) => post.copyWith(
            userType: _userType,
            estateType: _estateType,
            apartmentType: _apartmentType,
            dealType: _dealType,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          minHeight: SizeConfig.safeBlockVertical * 100.0,
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleField(
                  title: AppLocalizations.of(context)!.userTypeTitle,
                  values: UserType.values,
                  onPressed: (UserType value) =>
                      setState(() => _userType = value),
                  getDescription: userTypeDescription,
                ),
                ToggleField(
                  title: AppLocalizations.of(context)!.estateTypeTitle,
                  values: EstateType.values,
                  onPressed: (EstateType value) => setState(() {
                    if (value == EstateType.house) {
                      _apartmentType = null;
                    }
                    _estateType = value;
                  }),
                  getDescription: estateTypeDescription,
                ),
                Visibility(
                  visible: _estateType == EstateType.apartment,
                  child: ToggleField(
                    title: AppLocalizations.of(context)!.apartmentTypeTitle,
                    values: ApartmentType.values,
                    onPressed: (ApartmentType value) =>
                        setState(() => _apartmentType = value),
                    getDescription: apartmentTypeDescription,
                  ),
                ),
                ToggleField(
                  title: AppLocalizations.of(context)!.dealTypeTitle,
                  values: DealType.values,
                  onPressed: (DealType value) =>
                      setState(() => _dealType = value),
                  getDescription: dealTypeDescription,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
