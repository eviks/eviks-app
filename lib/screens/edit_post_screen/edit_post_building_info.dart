import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/post.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/styled_input.dart';
import './step_title.dart';

class EditPostBuildingInfo extends StatefulWidget {
  final Post post;
  final Function(Post) updatePost;

  const EditPostBuildingInfo({
    required this.post,
    required this.updatePost,
    Key? key,
  }) : super(key: key);

  @override
  _EditPostBuildingInfoState createState() => _EditPostBuildingInfoState();
}

class _EditPostBuildingInfoState extends State<EditPostBuildingInfo> {
  final _formKey = GlobalKey<FormState>();

  int? _yearBuild;
  double? _ceilingHeight;
  bool? _elevator = false;
  bool? _parkingLot = false;

  void _continuePressed() {
    if (_formKey.currentState == null) {
      return;
    }

    _formKey.currentState!.save();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.updatePost(widget.post.copyWith(
      yearBuild: _yearBuild,
      ceilingHeight: _ceilingHeight,
      elevator: _elevator,
      parkingLot: _parkingLot,
      step: 4,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.safeBlockHorizontal * 15.0, vertical: 32.0),
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                  height: 16.0,
                ),
                StyledElevatedButton(
                  text: AppLocalizations.of(context)!.next,
                  onPressed: _continuePressed,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
