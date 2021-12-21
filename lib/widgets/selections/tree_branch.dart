import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/settlement.dart';
import '../../widgets/custom_labeled_checkbox.dart';

class TreeBranch extends StatefulWidget {
  final Settlement district;
  final List<Settlement> selectedDistricts;
  final List<Settlement> selectedSubdistricts;
  final Function(Settlement, bool?, List<bool>) updateSelectedSettlements;
  final String? searchString;

  const TreeBranch({
    required this.district,
    required this.updateSelectedSettlements,
    required this.selectedDistricts,
    required this.selectedSubdistricts,
    this.searchString,
    Key? key,
  }) : super(key: key);

  @override
  _TreeBranchState createState() => _TreeBranchState();
}

class _TreeBranchState extends State<TreeBranch> {
  late bool? _parentValue;
  late List<Settlement> _children;
  late final List<bool> _childrenValue;

  late bool _parentMatches;
  late bool _childrenMatch;

  @override
  void didChangeDependencies() {
    _parentValue = false;

    _children = widget.district.children ?? [];

    if (_settlementIsSelected(widget.selectedDistricts, widget.district)) {
      _parentValue = true;
      _childrenValue = List.generate(_children.length, (index) => true);
    } else {
      _childrenValue = _children
          .map((Settlement subdistrict) =>
              _settlementIsSelected(widget.selectedSubdistricts, subdistrict))
          .toList();
      _parentValue = _childrenValue.contains(true) ? null : false;
    }

    _parentMatches = (widget.searchString == null) ||
        _searchStringMatch(widget.district.name);

    _childrenMatch = widget.district.children?.firstWhereOrNull(
            (subdistrict) => _searchStringMatch(subdistrict.name)) !=
        null;

    super.didChangeDependencies();
  }

  bool _settlementIsSelected(List<Settlement> list, Settlement settlement) {
    return list.firstWhereOrNull((element) => element.id == settlement.id) !=
        null;
  }

  bool _searchStringMatch(String value) {
    return removeAzerbaijaniChars(value).contains(
      RegExp(
        removeAzerbaijaniChars(widget.searchString ?? ''),
        caseSensitive: false,
      ),
    );
  }

  void _manageTristate(int index, bool value) {
    setState(() {
      if (value) {
        _childrenValue[index] = true;
        if (_childrenValue.contains(false)) {
          _parentValue = null;
        } else {
          _checkAll(true);
        }
      } else {
        _childrenValue[index] = false;
        if (_childrenValue.contains(true)) {
          _parentValue = null;
        } else {
          _checkAll(false);
        }
      }
    });
  }

  void _checkAll(bool value) {
    setState(() {
      _parentValue = value;

      for (int i = 0; i < _children.length; i++) {
        _childrenValue[i] = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        Visibility(
          visible: _parentMatches || _childrenMatch,
          child: CustomLabeledCheckbox(
            label: widget.district.name,
            value: _parentValue,
            onChanged: (value) {
              if (value != null) {
                _checkAll(value);
              } else {
                _checkAll(true);
              }
              widget.updateSelectedSettlements(
                  widget.district, _parentValue, _childrenValue);
            },
            checkboxType: CheckboxType.parent,
            labelStyle: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          itemCount: _children.length,
          itemBuilder: (context, index) => Visibility(
            visible: _searchStringMatch(_children[index].name),
            child: CustomLabeledCheckbox(
              label: _children[index].name,
              value: _childrenValue[index],
              onChanged: (value) {
                _manageTristate(index, value!);
                widget.updateSelectedSettlements(
                    widget.district, _parentValue, _childrenValue);
              },
            ),
          ),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
        ),
      ],
    );
  }
}
