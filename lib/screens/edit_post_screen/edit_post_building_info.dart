import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import './edit_post_additional_info.dart';
import './step_title.dart';
import '../../models/post.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/styled_input.dart';

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
  bool _isInit = true;

  final _formKey = GlobalKey<FormState>();

  int? _yearBuild;
  double? _ceilingHeight;
  bool? _elevator = false;
  bool? _parkingLot = false;

  @override
  void didChangeDependencies() {
    postData = Provider.of<Posts>(context, listen: true).postData;
    if (_isInit) {
      if ((postData?.lastStep ?? -1) >= 4) {
        _yearBuild = postData?.yearBuild;
        _ceilingHeight = postData?.ceilingHeight;
        _elevator = postData?.elevator;
        _parkingLot = postData?.parkingLot;
      }

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
        MaterialPageRoute(
            builder: (context) => const EditPostAdditionalInfo()));
  }

  void _updatePost() {
    Provider.of<Posts>(context, listen: false).setPostData(
      postData?.copyWith(
        yearBuild: _yearBuild,
        ceilingHeight: _ceilingHeight,
        elevator: _elevator,
        parkingLot: _parkingLot,
        lastStep: 4,
        step: _goToNextStep ? 5 : 3,
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
          title: AppLocalizations.of(context)!.buildingInfo,
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
            padding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 15.0,
                8.0, SizeConfig.safeBlockHorizontal * 15.0, 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: SizeConfig.safeBlockHorizontal * 40.0,
                    child: StyledInput(
                      icon: CustomIcons.calendar,
                      title: AppLocalizations.of(context)!.yearBuild,
                      initialValue:
                          _yearBuild != 0 ? _yearBuild?.toString() : null,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onSaved: (value) {
                        _ceilingHeight =
                            value?.isEmpty ?? true ? 0 : double.parse(value!);
                      },
                    ),
                  ),
                  Visibility(
                    visible: postData?.estateType == EstateType.apartment,
                    child: SwitchListTile(
                        value: _elevator ?? false,
                        secondary: Icon(
                          CustomIcons.elevator,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(AppLocalizations.of(context)!.elevator),
                        onChanged: (bool? value) {
                          setState(() {
                            _elevator = value;
                          });
                        }),
                  ),
                  Visibility(
                    visible: postData?.estateType == EstateType.apartment,
                    child: SwitchListTile(
                        value: _parkingLot ?? false,
                        secondary: Icon(
                          CustomIcons.parkinglot,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(AppLocalizations.of(context)!.parkingLot),
                        onChanged: (bool? value) {
                          setState(() {
                            _parkingLot = value;
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
