import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/styled_input.dart';
import '../../widgets/toggle_field.dart';
import './edit_post_building_info.dart';
import './step_title.dart';

class EditPostEstateInfo extends StatefulWidget {
  const EditPostEstateInfo({
    Key? key,
  }) : super(key: key);

  @override
  _EditPostEstateInfoState createState() => _EditPostEstateInfoState();
}

class _EditPostEstateInfoState extends State<EditPostEstateInfo> {
  late Post? postData;
  bool _goToNextStep = false;
  bool _isInit = true;

  final _formKey = GlobalKey<FormState>();

  int? _rooms;
  int? _sqm;
  int? _livingRoomsSqm;
  int? _kitchenSqm;
  int? _lotSqm;
  int? _floor;
  int? _totalFloors;
  Renovation? _renovation;
  bool? _redevelopment = false;
  bool? _documented = false;

  final _totalFloorsController = TextEditingController();

  late bool _isHouse;

  @override
  void didChangeDependencies() {
    postData = Provider.of<Posts>(context).postData;
    if (_isInit) {
      if ((postData?.lastStep ?? -1) >= 3) {
        _rooms = postData?.rooms;
        _sqm = postData?.sqm;
        _livingRoomsSqm = postData?.livingRoomsSqm;
        _kitchenSqm = postData?.kitchenSqm;
        _lotSqm = postData?.lotSqm;
        _floor = postData?.floor;
        _totalFloors = postData?.totalFloors;
        _renovation = postData?.renovation;
        _redevelopment = postData?.redevelopment;
        _documented = postData?.documented;
      }

      _totalFloorsController.text =
          _totalFloors != 0 ? _totalFloors?.toString() ?? '' : '';

      _isHouse = postData?.estateType == EstateType.house;

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
      MaterialPageRoute(builder: (context) => const EditPostBuildingInfo()),
    );
  }

  void _updatePost() {
    Provider.of<Posts>(context, listen: false).setPostData(
      postData?.copyWith(
        rooms: _rooms,
        sqm: _sqm,
        livingRoomsSqm: _livingRoomsSqm,
        kitchenSqm: _kitchenSqm,
        lotSqm: _lotSqm,
        floor: _floor,
        totalFloors: _totalFloors,
        renovation: _renovation,
        redevelopment: _redevelopment,
        documented: _documented,
        lastStep: 3,
        step: _goToNextStep ? 4 : 2,
      ),
    );
  }

  void _prevStep() {
    _formKey.currentState!.save();
    _updatePost();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _totalFloorsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: StepTitle(
          title: AppLocalizations.of(context)!.estateInfo,
        ),
        leading: IconButton(
          onPressed: () {
            _prevStep();
          },
          icon: const Icon(LucideIcons.arrowLeft),
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
                        icon: CustomIcons.door,
                        title: AppLocalizations.of(context)!.rooms,
                        initialValue: _rooms != 0 ? _rooms?.toString() : null,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .errorRequiredField;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _rooms =
                              value?.isEmpty ?? true ? 0 : int.parse(value!);
                        },
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 40.0,
                      child: StyledInput(
                        icon: CustomIcons.sqm,
                        title: AppLocalizations.of(context)!.sqm,
                        initialValue: _sqm != 0 ? _sqm?.toString() : null,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .errorRequiredField;
                          }
                          return null;
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
                        initialValue: _livingRoomsSqm != 0
                            ? _livingRoomsSqm?.toString()
                            : null,
                        keyboardType: TextInputType.number,
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
                        initialValue:
                            _kitchenSqm != 0 ? _kitchenSqm?.toString() : null,
                        keyboardType: TextInputType.number,
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
                          icon: CustomIcons.garden,
                          title: AppLocalizations.of(context)!.lotSqm,
                          initialValue:
                              _lotSqm != 0 ? _lotSqm?.toString() : null,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (_isHouse && (value == null || value.isEmpty)) {
                              return AppLocalizations.of(context)!
                                  .errorRequiredField;
                            }
                            return null;
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: SizeConfig.safeBlockHorizontal * 25.0,
                            child: StyledInput(
                              icon: CustomIcons.elevator,
                              title: AppLocalizations.of(context)!.floor,
                              initialValue:
                                  _floor != 0 ? _floor?.toString() : null,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (_isHouse) {
                                  return null;
                                } else if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .errorRequiredField;
                                } else if (_totalFloorsController
                                        .value.text.isNotEmpty &&
                                    int.parse(
                                          _totalFloorsController.value.text,
                                        ) <
                                        int.parse(value)) {
                                  return AppLocalizations.of(context)!
                                      .errorFloor;
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _floor = value?.isEmpty ?? true
                                    ? 0
                                    : int.parse(value!);
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 40.0,
                            ),
                            child: Text(' - '),
                          ),
                          SizedBox(
                            width: SizeConfig.safeBlockHorizontal * 25.0,
                            child: StyledInput(
                              title: '',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              controller: _totalFloorsController,
                              validator: (value) {
                                if (!_isHouse &&
                                    (value == null || value.isEmpty)) {
                                  return AppLocalizations.of(context)!
                                      .errorRequiredField;
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _totalFloors = value?.isEmpty ?? true
                                    ? 0
                                    : int.parse(value!);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _isHouse,
                      child: SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 40.0,
                        child: StyledInput(
                          icon: CustomIcons.elevator,
                          title:
                              AppLocalizations.of(context)!.totalFloorsInHouse,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: _totalFloorsController,
                          onSaved: (value) {
                            _totalFloors =
                                value?.isEmpty ?? true ? 0 : int.parse(value!);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    SwitchListTile(
                      value: _documented ?? false,
                      secondary: Icon(
                        CustomIcons.document,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      title: Text(AppLocalizations.of(context)!.documented),
                      onChanged: (bool? value) {
                        setState(() {
                          _documented = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      value: _redevelopment ?? false,
                      secondary: Icon(
                        CustomIcons.hammer,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      title: Text(AppLocalizations.of(context)!.redevelopment),
                      onChanged: (bool? value) {
                        setState(() {
                          _redevelopment = value;
                        });
                      },
                    ),
                    ToggleFormField<Renovation>(
                      title: AppLocalizations.of(context)!.renovation,
                      values: Renovation.values,
                      initialValue: _renovation,
                      getDescription: renovationDescription,
                      direction: Axis.vertical,
                      validator: (value) {
                        if (value == null) {
                          return AppLocalizations.of(context)!.fieldIsRequired;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _renovation = value;
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
      ),
      bottomNavigationBar: StyledElevatedButton(
        secondary: true,
        text: AppLocalizations.of(context)!.next,
        onPressed: _continuePressed,
        width: SizeConfig.safeBlockHorizontal * 100.0,
        suffixIcon: LucideIcons.arrowRight,
      ),
    );
  }
}
