import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';
import '../../models/failure.dart';
import '../../models/settlement.dart';
import '../../providers/localities.dart';
import './tree_branch.dart';

class DistrictSelection extends StatefulWidget {
  final Settlement city;
  final List<Settlement> selectedDistricts;
  final List<Settlement> selectedSubdistricts;

  const DistrictSelection({
    required this.city,
    required this.selectedDistricts,
    required this.selectedSubdistricts,
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
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      _selectedDistricts = widget.selectedDistricts;
      _selectedSubdistricts = widget.selectedSubdistricts;

      String _errorMessage = '';
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      final result = await Provider.of<Localities>(context, listen: false)
          .getLocalitiesByIds(
              widget.city.children?.map((e) => e.id).toList() ?? []);
      try {
        setState(() {
          _districts = result;
          _districts = result;
        });
      } on Failure catch (error) {
        if (error.statusCode >= 500) {
          _errorMessage = AppLocalizations.of(context)!.serverError;
        } else {
          _errorMessage = AppLocalizations.of(context)!.networkError;
        }
      } catch (error) {
        _errorMessage = AppLocalizations.of(context)!.unknownError;
      }

      if (_errorMessage.isNotEmpty) {
        displayErrorMessage(context, _errorMessage);
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
      Settlement district, bool? parentValue, List<bool> childrenValue) {
    setState(() {
      if (parentValue == true) {
        _selectedDistricts.add(district);
        for (final Settlement subdistrict in district.children ?? []) {
          _selectedSubdistricts.remove(subdistrict);
        }
      } else {
        _selectedDistricts.remove(district);
        for (int index = 0; index < (district.children?.length ?? 0); index++) {
          if (childrenValue[index] &&
              !_selectedSubdistricts.contains(district.children![index])) {
            _selectedSubdistricts.add(district.children![index]);
          } else if (!childrenValue[index] &&
              _selectedSubdistricts.contains(district.children![index])) {
            _selectedSubdistricts.remove(district.children![index]);
          }
        }
      }
    });
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
          AppLocalizations.of(context)!.selectDistrict,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? (const Center(
              child: CircularProgressIndicator(),
            ))
          : Padding(
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
                      key: ValueKey(_searchString),
                      itemBuilder: (contex, index) => TreeBranch(
                        key: Key(_districts[index].id),
                        district: _districts[index],
                        selectedDistricts: _selectedDistricts,
                        selectedSubdistricts: _selectedSubdistricts,
                        updateSelectedSettlements: _updateSelectedSettlements,
                        searchString: _searchString,
                      ),
                      itemCount: _districts.length,
                      shrinkWrap: true,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
