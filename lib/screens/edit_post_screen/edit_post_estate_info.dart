import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/post.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/styled_input.dart';
import './step_title.dart';

class EditPostEstateInfo extends StatefulWidget {
  final Post post;
  final Function(Post) updatePost;

  const EditPostEstateInfo({
    required this.post,
    required this.updatePost,
    Key? key,
  }) : super(key: key);

  @override
  _EditPostEstateInfoState createState() => _EditPostEstateInfoState();
}

class _EditPostEstateInfoState extends State<EditPostEstateInfo> {
  final _formKey = GlobalKey<FormState>();

  int? _rooms;
  int? _sqm;
  int? _livingRoomsSqm;
  int? _kitchenSqm;
  int? _lotSqm;
  int? _floor;
  int? _totalFloors;

  final _totalFloorsController = TextEditingController();

  late bool _isHouse;

  @override
  void initState() {
    _isHouse = widget.post.estateType == EstateType.house;
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

    widget.updatePost(widget.post.copyWith(
      rooms: _rooms,
      sqm: _sqm,
      livingRoomsSqm: _livingRoomsSqm,
      kitchenSqm: _kitchenSqm,
      lotSqm: _lotSqm,
      floor: _floor,
      totalFloors: _totalFloors,
      step: 3,
    ));
  }

  void _prevStep() {
    widget.updatePost(widget.post.copyWith(
      step: 1,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StepTitle(
                  title: AppLocalizations.of(context)!.estateInfo,
                  icon: CustomIcons.house,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 40.0,
                  child: StyledInput(
                    icon: CustomIcons.door,
                    title: AppLocalizations.of(context)!.rooms,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.errorRequiredField;
                      }
                    },
                    onSaved: (value) {
                      _rooms = value?.isEmpty ?? true ? 0 : int.parse(value!);
                    },
                  ),
                ),
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 40.0,
                  child: StyledInput(
                    icon: CustomIcons.sqm,
                    title: AppLocalizations.of(context)!.sqm,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.errorRequiredField;
                      }
                    },
                    onSaved: (value) {
                      _sqm = value?.isEmpty ?? true ? 0 : int.parse(value!);
                    },
                  ),
                ),
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 40.0,
                  child: StyledInput(
                    icon: CustomIcons.sqm,
                    title: AppLocalizations.of(context)!.livingRoomsSqm,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.errorRequiredField;
                      }
                    },
                    onSaved: (value) {
                      _livingRoomsSqm =
                          value?.isEmpty ?? true ? 0 : int.parse(value!);
                    },
                  ),
                ),
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 40.0,
                  child: StyledInput(
                    icon: CustomIcons.sqm,
                    title: AppLocalizations.of(context)!.kitchenSqm,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.errorRequiredField;
                      }
                    },
                    onSaved: (value) {
                      _kitchenSqm =
                          value?.isEmpty ?? true ? 0 : int.parse(value!);
                    },
                  ),
                ),
                Visibility(
                  visible: _isHouse,
                  child: SizedBox(
                    width: SizeConfig.safeBlockHorizontal * 40.0,
                    child: StyledInput(
                      icon: CustomIcons.sqm,
                      title: AppLocalizations.of(context)!.lotSqm,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!
                              .errorRequiredField;
                        }
                      },
                      onSaved: (value) {
                        _lotSqm =
                            value?.isEmpty ?? true ? 0 : int.parse(value!);
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: !_isHouse,
                  child: SizedBox(
                    width: SizeConfig.safeBlockHorizontal * 40.0,
                    child: StyledInput(
                      icon: CustomIcons.stairs,
                      title: AppLocalizations.of(context)!.floor,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!
                              .errorRequiredField;
                        } else if (int.parse(
                                _totalFloorsController.value.text) <
                            int.parse(value)) {
                          return AppLocalizations.of(context)!.errorFloor;
                        }
                      },
                      onSaved: (value) {
                        _floor = value?.isEmpty ?? true ? 0 : int.parse(value!);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 40.0,
                  child: StyledInput(
                    icon: CustomIcons.stairs,
                    title: AppLocalizations.of(context)!.totalFloors,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: _totalFloorsController,
                    validator: (value) {
                      if (!_isHouse && (value == null || value.isEmpty)) {
                        return AppLocalizations.of(context)!.errorRequiredField;
                      }
                    },
                    onSaved: (value) {
                      _totalFloors =
                          value?.isEmpty ?? true ? 0 : int.parse(value!);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 32.0
                          : 0),
                  child: Column(
                    children: [
                      StyledElevatedButton(
                        text: AppLocalizations.of(context)!.next,
                        onPressed: _continuePressed,
                        width: SizeConfig.safeBlockHorizontal * 50,
                      ),
                      StyledElevatedButton(
                        text: AppLocalizations.of(context)!.back,
                        onPressed: _prevStep,
                        width: SizeConfig.safeBlockHorizontal * 50,
                        secondary: true,
                      ),
                    ],
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
