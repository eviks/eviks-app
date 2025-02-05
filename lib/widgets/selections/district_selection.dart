import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/failure.dart';
import '../../models/settlement.dart';
import '../../providers/localities.dart';
import '../../widgets/styled_elevated_button.dart';
import './tree_branch.dart';

enum SubdistrictSelectMode { multiple, single }

class DistrictSelection extends StatefulWidget {
  final Settlement city;
  final List<Settlement> selectedDistricts;
  final List<Settlement> selectedSubdistricts;
  final SubdistrictSelectMode selecMode;

  const DistrictSelection({
    required this.city,
    required this.selectedDistricts,
    required this.selectedSubdistricts,
    this.selecMode = SubdistrictSelectMode.multiple,
    Key? key,
  }) : super(key: key);

  @override
  _DistrictSelectionState createState() => _DistrictSelectionState();
}

class _DistrictSelectionState extends State<DistrictSelection> {
  var _isInit = true;
  var _isLoading = false;
  String _searchString = '';

  late List<Settlement> _districts;
  late List<Settlement> _selectedDistricts;
  late List<Settlement> _selectedSubdistricts;
  late TextEditingController _controller;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      _selectedDistricts = widget.selectedDistricts;
      _selectedSubdistricts = widget.selectedSubdistricts;

      String errorMessage = '';
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      final result =
          await Provider.of<Localities>(context, listen: false).getLocalities({
        'id': widget.city.children?.map((e) => e.id).toList().join(',') ?? '',
      });

      if (!mounted) return;

      try {
        setState(() {
          _districts = result;
        });
      } on Failure catch (error) {
        if (error.statusCode >= 500) {
          errorMessage = AppLocalizations.of(context)!.serverError;
        } else {
          errorMessage = AppLocalizations.of(context)!.networkError;
        }
      } catch (error) {
        errorMessage = AppLocalizations.of(context)!.unknownError;
      }

      if (errorMessage.isNotEmpty) {
        showSnackBar(context, errorMessage);
      }

      setState(() {
        _isLoading = false;
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSelectedSettlements(
    Settlement district,
    bool? parentValue,
    List<bool> childrenValue,
  ) {
    setState(() {
      if (parentValue == true) {
        _selectedDistricts.add(district);
        for (final Settlement subdistrict in district.children ?? []) {
          _selectedSubdistricts
              .removeWhere((element) => element.id == subdistrict.id);
        }
      } else {
        _selectedDistricts.removeWhere((element) => element.id == district.id);
        for (int index = 0; index < (district.children?.length ?? 0); index++) {
          if (childrenValue[index] &&
              !_settlementIsSelected(
                _selectedSubdistricts,
                district.children![index],
              )) {
            _selectedSubdistricts.add(district.children![index]);
          } else if (!childrenValue[index] &&
              _settlementIsSelected(
                _selectedSubdistricts,
                district.children![index],
              )) {
            _selectedSubdistricts.removeWhere(
              (element) => element.id == district.children![index].id,
            );
          }
        }
      }
    });
  }

  bool _settlementIsSelected(List<Settlement> list, Settlement settlement) {
    return list.firstWhereOrNull((element) => element.id == settlement.id) !=
        null;
  }

  void _onSingleSelect(Settlement district, Settlement? subdistrict) {
    final Map<String, List<Settlement>> value = {};

    value['districts'] = [district];
    if (subdistrict != null) {
      value['subdistricts'] = [subdistrict];
    }

    Navigator.of(context).pop(value);
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
                icon: const Icon(LucideIcons.arrowLeft),
              )
            : null,
        title: Text(
          AppLocalizations.of(context)!.selectDistrict,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        scrolledUnderElevation: 0.0,
      ),
      body: _isLoading
          ? (const Center(
              child: CircularProgressIndicator(),
            ))
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      cursorColor: Theme.of(context).iconTheme.color,
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.selectDistrictHint,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        fillColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                        filled: true,
                        suffixIcon: const Icon(Icons.saved_search),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _searchString = _controller.text;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80.0),
                        key: ValueKey(_searchString),
                        itemBuilder: (contex, index) => TreeBranch(
                          key: Key(_districts[index].id),
                          district: _districts[index],
                          selectedDistricts: _selectedDistricts,
                          selectedSubdistricts: _selectedSubdistricts,
                          updateSelectedSettlements: _updateSelectedSettlements,
                          searchString: _searchString,
                          selectMode: widget.selecMode,
                          onSingleSelect:
                              widget.selecMode == SubdistrictSelectMode.multiple
                                  ? null
                                  : _onSingleSelect,
                        ),
                        itemCount: _districts.length,
                        shrinkWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: widget.selecMode == SubdistrictSelectMode.multiple
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: StyledElevatedButton(
                text: AppLocalizations.of(context)!.select,
                onPressed: () {
                  Navigator.of(context).pop({
                    'districts': _selectedDistricts,
                    'subdistricts': _selectedSubdistricts,
                  });
                },
              ),
            )
          : null,
    );
  }
}
