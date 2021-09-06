import 'package:flutter/material.dart';

class ToggleField extends StatefulWidget {
  final String name;
  final String title;
  final List values;
  final Function(String, dynamic) setValue;
  final Function getDescription;

  const ToggleField({
    Key? key,
    required this.name,
    required this.title,
    required this.values,
    required this.setValue,
    required this.getDescription,
  }) : super(key: key);

  @override
  _ToggleFieldState createState() => _ToggleFieldState();
}

class _ToggleFieldState extends State<ToggleField> {
  late List<bool> _selections;

  @override
  void initState() {
    _selections = List.generate(widget.values.length, (index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title),
        const SizedBox(
          height: 2.0,
        ),
        ToggleButtons(
          borderRadius: BorderRadius.circular(50.0),
          isSelected: _selections,
          onPressed: (int newIndex) {
            widget.setValue(widget.name, widget.values[newIndex]);
            setState(() {
              for (int index = 0; index < _selections.length; index++) {
                _selections[index] = index == newIndex;
              }
            });
          },
          children: widget.values
              .map<Widget>(
                (value) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                  ),
                  child: Text(widget.getDescription(value, context) as String),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
