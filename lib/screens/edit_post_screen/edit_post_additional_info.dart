import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/post.dart';
import '../../widgets/icon_choise_chip.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/styled_input.dart';
import './step_title.dart';

class EditPostAdditionalInfo extends StatefulWidget {
  final Post post;
  final Function(Post) updatePost;

  const EditPostAdditionalInfo({
    required this.post,
    required this.updatePost,
    Key? key,
  }) : super(key: key);

  @override
  _EditPostAdditionalInfoState createState() => _EditPostAdditionalInfoState();
}

class _EditPostAdditionalInfoState extends State<EditPostAdditionalInfo> {
  final _formKey = GlobalKey<FormState>();

  String? _description;
  bool? _balcony;
  bool? _furniture;
  bool? _kitchenFurniture;
  bool? _cableTv;
  bool? _phone;
  bool? _internet;
  bool? _electricity;
  bool? _gas;
  bool? _water;
  bool? _heating;
  bool? _tv;
  bool? _conditioner;
  bool? _washingMachine;
  bool? _dishwasher;
  bool? _refrigerator;
  bool? _kidsAllowed;
  bool? _petsAllowed;
  bool? _garage;
  bool? _pool;
  bool? _bathhouse;

  late bool _isHouse;
  late bool _isSale;

  @override
  void initState() {
    _isHouse = widget.post.estateType == EstateType.house;
    _isSale = widget.post.dealType == DealType.sale;
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
      description: _description,
      balcony: _balcony,
      furniture: _furniture,
      kitchenFurniture: _kitchenFurniture,
      cableTv: _cableTv,
      phone: _phone,
      internet: _internet,
      electricity: _electricity,
      gas: _gas,
      water: _water,
      heating: _heating,
      tv: _tv,
      conditioner: _conditioner,
      washingMachine: _washingMachine,
      dishwasher: _dishwasher,
      refrigerator: _refrigerator,
      kidsAllowed: _kidsAllowed,
      petsAllowed: _petsAllowed,
      garage: _garage,
      pool: _pool,
      bathhouse: _bathhouse,
      step: 5,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.safeBlockHorizontal * 8.0, vertical: 32.0),
        child: Center(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StepTitle(
                  title: AppLocalizations.of(context)!.additionalInfo,
                  icon: CustomIcons.plus,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                StyledInput(
                  title: AppLocalizations.of(context)!.description,
                  hintText: AppLocalizations.of(context)!.descriptionHint,
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: null,
                  onSaved: (value) {
                    _description = value;
                  },
                  validator: (value) {
                    if (value == null ||
                        value.replaceAll(RegExp('[^a-zA-Z]'), '').length < 50) {
                      return AppLocalizations.of(context)!.descriptionMinLength;
                    }
                  },
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    Visibility(
                      visible: !_isSale,
                      child: IconChoiseChip(
                          icon: CustomIcons.kids,
                          label:
                              Text(AppLocalizations.of(context)!.kidsAllowed),
                          value: _kidsAllowed ?? false,
                          onSelected: (bool selected) {
                            setState(() {
                              _kidsAllowed = selected;
                            });
                          }),
                    ),
                    Visibility(
                      visible: !_isSale,
                      child: IconChoiseChip(
                          icon: CustomIcons.pets,
                          label:
                              Text(AppLocalizations.of(context)!.petsAllowed),
                          value: _petsAllowed ?? false,
                          onSelected: (bool selected) {
                            setState(() {
                              _petsAllowed = selected;
                            });
                          }),
                    ),
                    Visibility(
                      visible: _isHouse,
                      child: IconChoiseChip(
                          icon: CustomIcons.garage,
                          label: Text(AppLocalizations.of(context)!.garage),
                          value: _garage ?? false,
                          onSelected: (bool selected) {
                            setState(() {
                              _garage = selected;
                            });
                          }),
                    ),
                    Visibility(
                      visible: _isHouse,
                      child: IconChoiseChip(
                          icon: CustomIcons.pool,
                          label: Text(AppLocalizations.of(context)!.pool),
                          value: _pool ?? false,
                          onSelected: (bool selected) {
                            setState(() {
                              _pool = selected;
                            });
                          }),
                    ),
                    Visibility(
                      visible: _isHouse,
                      child: IconChoiseChip(
                          icon: CustomIcons.bathhouse,
                          label: Text(AppLocalizations.of(context)!.bathhouse),
                          value: _bathhouse ?? false,
                          onSelected: (bool selected) {
                            setState(() {
                              _bathhouse = selected;
                            });
                          }),
                    ),
                    IconChoiseChip(
                        icon: CustomIcons.balcony,
                        label: Text(AppLocalizations.of(context)!.balcony),
                        value: _balcony ?? false,
                        onSelected: (bool selected) {
                          setState(() {
                            _balcony = selected;
                          });
                        }),
                    IconChoiseChip(
                        icon: CustomIcons.furniture,
                        label: Text(AppLocalizations.of(context)!.furniture),
                        value: _furniture ?? false,
                        onSelected: (bool selected) {
                          setState(() {
                            _furniture = selected;
                          });
                        }),
                    IconChoiseChip(
                        icon: CustomIcons.kitchenfurniture,
                        label: Text(
                            AppLocalizations.of(context)!.kitchenFurniture),
                        value: _kitchenFurniture ?? false,
                        onSelected: (bool selected) {
                          setState(() {
                            _kitchenFurniture = selected;
                          });
                        }),
                    IconChoiseChip(
                        icon: CustomIcons.tv,
                        label: Text(AppLocalizations.of(context)!.cabelTv),
                        value: _cableTv ?? false,
                        onSelected: (bool selected) {
                          setState(() {
                            _cableTv = selected;
                          });
                        }),
                    IconChoiseChip(
                        icon: CustomIcons.phone,
                        label: Text(AppLocalizations.of(context)!.phone),
                        value: _phone ?? false,
                        onSelected: (bool selected) {
                          setState(() {
                            _phone = selected;
                          });
                        }),
                    IconChoiseChip(
                        icon: CustomIcons.internet,
                        label: Text(AppLocalizations.of(context)!.internet),
                        value: _internet ?? false,
                        onSelected: (bool selected) {
                          setState(() {
                            _internet = selected;
                          });
                        }),
                    IconChoiseChip(
                        icon: CustomIcons.electricity,
                        label: Text(AppLocalizations.of(context)!.electricity),
                        value: _electricity ?? false,
                        onSelected: (bool selected) {
                          setState(() {
                            _electricity = selected;
                          });
                        }),
                    IconChoiseChip(
                        icon: CustomIcons.gas,
                        label: Text(AppLocalizations.of(context)!.gas),
                        value: _gas ?? false,
                        onSelected: (bool selected) {
                          setState(() {
                            _gas = selected;
                          });
                        }),
                    IconChoiseChip(
                        icon: CustomIcons.water,
                        label: Text(AppLocalizations.of(context)!.water),
                        value: _water ?? false,
                        onSelected: (bool selected) {
                          setState(() {
                            _water = selected;
                          });
                        }),
                    IconChoiseChip(
                        icon: CustomIcons.heat,
                        label: Text(AppLocalizations.of(context)!.heating),
                        value: _heating ?? false,
                        onSelected: (bool selected) {
                          setState(() {
                            _heating = selected;
                          });
                        }),
                    IconChoiseChip(
                        icon: CustomIcons.tv,
                        label: Text(AppLocalizations.of(context)!.tv),
                        value: _tv ?? false,
                        onSelected: (bool selected) {
                          setState(() {
                            _tv = selected;
                          });
                        }),
                    IconChoiseChip(
                        icon: CustomIcons.conditioner,
                        label: Text(AppLocalizations.of(context)!.conditioner),
                        value: _conditioner ?? false,
                        onSelected: (bool selected) {
                          setState(() {
                            _conditioner = selected;
                          });
                        }),
                    IconChoiseChip(
                        icon: CustomIcons.washingmachine,
                        label:
                            Text(AppLocalizations.of(context)!.washingMachine),
                        value: _washingMachine ?? false,
                        onSelected: (bool selected) {
                          setState(() {
                            _washingMachine = selected;
                          });
                        }),
                    IconChoiseChip(
                        icon: CustomIcons.dishwasher,
                        label: Text(AppLocalizations.of(context)!.dishwasher),
                        value: _dishwasher ?? false,
                        onSelected: (bool selected) {
                          setState(() {
                            _dishwasher = selected;
                          });
                        }),
                    IconChoiseChip(
                        icon: CustomIcons.refrigerator,
                        label: Text(AppLocalizations.of(context)!.refrigerator),
                        value: _refrigerator ?? false,
                        onSelected: (bool selected) {
                          setState(() {
                            _refrigerator = selected;
                          });
                        }),
                  ],
                ),
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
