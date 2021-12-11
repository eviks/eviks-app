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

class EditPostBuildingInfo extends StatefulWidget {
  const EditPostBuildingInfo({
    Key? key,
  }) : super(key: key);

  @override
  _EditPostBuildingInfoState createState() => _EditPostBuildingInfoState();
}

class _EditPostBuildingInfoState extends State<EditPostBuildingInfo> {
  late Post? postData;
  bool _goToNextStep = false;

  final _formKey = GlobalKey<FormState>();

  int? _yearBuild;
  double? _ceilingHeight;
  bool? _elevator = false;
  bool? _parkingLot = false;

  @override
  void initState() {
    postData = Provider.of<Posts>(context, listen: false).postData;

    if ((postData?.lastStep ?? -1) >= 3) {
      _yearBuild = postData?.yearBuild;
      _ceilingHeight = postData?.ceilingHeight;
      _elevator = postData?.elevator;
      _parkingLot = postData?.parkingLot;
    }

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

  void _updatePost() {
    Provider.of<Posts>(context, listen: false).updatePost(
      postData?.copyWith(
        yearBuild: _yearBuild,
        ceilingHeight: _ceilingHeight,
        elevator: _elevator,
        parkingLot: _parkingLot,
        lastStep: 3,
        step: _goToNextStep ? 4 : 2,
      ),
    );
  }

  void _prevStep(Post? postData) {
    _updatePost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(),
        leading: IconButton(
          onPressed: () {
            _prevStep(postData);
          },
          icon: const Icon(CustomIcons.back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                      title: AppLocalizations.of(context)!.buildingInfo,
                      icon: CustomIcons.apartment,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 40.0,
                      child: StyledInput(
                        icon: CustomIcons.calendar,
                        title: AppLocalizations.of(context)!.yearBuild,
                        initialValue:
                            _yearBuild != 0 ? _yearBuild?.toString() : null,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onSaved: (value) {
                          _yearBuild =
                              value?.isEmpty ?? true ? 0 : int.parse(value!);
                        },
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 40.0,
                      child: StyledInput(
                        icon: CustomIcons.measuring,
                        title: AppLocalizations.of(context)!.ceilingHeight,
                        initialValue: _ceilingHeight != 0
                            ? _ceilingHeight?.toString()
                            : null,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onSaved: (value) {
                          _ceilingHeight =
                              value?.isEmpty ?? true ? 0 : double.parse(value!);
                        },
                      ),
                    ),
                    SwitchListTile(
                        value: _elevator ?? false,
                        secondary: const Icon(CustomIcons.elevator),
                        title: Text(AppLocalizations.of(context)!.elevator),
                        onChanged: (bool? value) {
                          setState(() {
                            _elevator = value;
                          });
                        }),
                    SwitchListTile(
                        value: _parkingLot ?? false,
                        secondary: const Icon(CustomIcons.parkinglot),
                        title: Text(AppLocalizations.of(context)!.parkingLot),
                        onChanged: (bool? value) {
                          setState(() {
                            _parkingLot = value;
                          });
                        }),
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
