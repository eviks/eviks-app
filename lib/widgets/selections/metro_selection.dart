import 'package:collection/collection.dart';
import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';
import '../../models/metro_station.dart';
import '../../widgets/custom_labeled_checkbox.dart';
import '../../widgets/styled_elevated_button.dart';

class MetroSelection extends StatefulWidget {
  final List<MetroStation> metroStations;
  final List<MetroStation> selectedMetroStations;

  const MetroSelection({
    required this.metroStations,
    required this.selectedMetroStations,
    Key? key,
  }) : super(key: key);

  @override
  _MetroSelectionState createState() => _MetroSelectionState();
}

class _MetroSelectionState extends State<MetroSelection> {
  List<MetroStation> _filteredMetroStations = [];
  List<MetroStation> _selectedMetroStations = [];
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    setState(() {
      _filteredMetroStations = widget.metroStations;
      _selectedMetroStations = widget.selectedMetroStations;
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(CustomIcons.back),
              )
            : null,
        title: Text(
          AppLocalizations.of(context)!.selectMetroStation,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        scrolledUnderElevation: 0.0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                cursorColor: Theme.of(context).iconTheme.color,
                decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context)!.selectMetroStationHint,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  filled: true,
                  suffixIcon: const Icon(Icons.saved_search),
                ),
                onChanged: (String value) {
                  setState(() {
                    _filteredMetroStations = widget.metroStations
                        .where(
                          (element) => removeAzerbaijaniChars(
                            element.getLocalizedName(context),
                          ).contains(
                            RegExp(
                              removeAzerbaijaniChars(value),
                              caseSensitive: false,
                            ),
                          ),
                        )
                        .toList();
                  });
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  itemBuilder: (ctx, index) {
                    return CustomLabeledCheckbox(
                      checkboxType: CheckboxType.parent,
                      label: _filteredMetroStations[index]
                          .getLocalizedName(context),
                      value: _selectedMetroStations.firstWhereOrNull(
                            (element) =>
                                element.id == _filteredMetroStations[index].id,
                          ) !=
                          null,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedMetroStations
                                .add(_filteredMetroStations[index]);
                          } else {
                            _selectedMetroStations.removeWhere(
                              (element) =>
                                  element.id ==
                                  _filteredMetroStations[index].id,
                            );
                          }
                        });
                      },
                    );
                  },
                  itemCount: _filteredMetroStations.length,
                ),
              ),
              const SizedBox(
                height: 32.0,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StyledElevatedButton(
          text: AppLocalizations.of(context)!.select,
          onPressed: () {
            Navigator.of(context).pop(
              _selectedMetroStations,
            );
          },
        ),
      ),
    );
  }
}
