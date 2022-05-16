import 'package:collection/collection.dart';
import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import './edit_post_estate_info.dart';
import './step_title.dart';
import '../../models/metro_station.dart';
import '../../models/post.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';

class EditPostMetro extends StatefulWidget {
  const EditPostMetro({
    Key? key,
  }) : super(key: key);

  @override
  _EditPostMetroState createState() => _EditPostMetroState();
}

class _EditPostMetroState extends State<EditPostMetro> {
  late Post? postData;
  List<MetroStation> _metroStations = [];
  bool _goToNextStep = false;

  final _formKey = GlobalKey<FormState>();

  MetroStation? _metroStation;

  @override
  void didChangeDependencies() {
    postData = Provider.of<Posts>(context, listen: true).postData;

    _metroStations = postData?.city.metroStations ?? [];
    _metroStations.sort((a, b) {
      return a
          .getLocalizedName(context)
          .toLowerCase()
          .compareTo(b.getLocalizedName(context).toLowerCase());
    });

    if ((postData?.lastStep ?? -1) >= 2) {
      _metroStation = postData?.metroStation;
    }

    super.didChangeDependencies();
  }

  void _dropdownCallback(MetroStation? selectedValue) {
    setState(() {
      _metroStation = selectedValue;
    });
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
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const EditPostEstateInfo()));
  }

  void _updatePost() {
    Provider.of<Posts>(context, listen: false).setPostData(
      postData?.copyWith(
        metroStation: _metroStation,
        lastStep: 2,
        step: _goToNextStep ? 3 : 1,
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
    return Scaffold(
      appBar: AppBar(
        title: StepTitle(
          title: AppLocalizations.of(context)!.metro,
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
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.metroHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(CustomIcons.metro),
                      ),
                      items: _metroStations
                          .map((station) => DropdownMenuItem(
                                value: station,
                                child: Text(
                                  station.getLocalizedName(context),
                                ),
                              ))
                          .toList(),
                      value: _metroStations.firstWhereOrNull(
                          (element) => element.id == _metroStation?.id),
                      onChanged: _dropdownCallback,
                      validator: (value) {
                        if (value == null) {
                          return AppLocalizations.of(context)!
                              .errorRequiredField;
                        }
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
        suffixIcon: CustomIcons.next,
      ),
    );
  }
}
