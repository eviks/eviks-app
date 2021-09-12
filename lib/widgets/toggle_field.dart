import 'package:flutter/material.dart';

class ToggleField extends StatefulWidget {
  final String title;
  final List values;
  final Function onPressed;
  final Function getDescription;

  const ToggleField({
    Key? key,
    required this.title,
    required this.values,
    required this.onPressed,
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
        const SizedBox(
          height: 16.0,
        ),
        Text(
          widget.title,
          style: const TextStyle(fontSize: 18.0),
        ),
        const SizedBox(
          height: 2.0,
        ),
        ToggleButtons(
          borderRadius: BorderRadius.circular(10.0),
          isSelected: _selections,
          onPressed: (int newIndex) {
            widget.onPressed(widget.values[newIndex]);
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
