import 'package:flutter/material.dart';

class ToggleField<EnumType> extends StatefulWidget {
  final FormFieldState<EnumType>? state;
  final String title;
  final List values;
  final Function getDescription;
  final Function? onPressed;
  final Axis direction;
  final EnumType? initialValue;

  const ToggleField({
    Key? key,
    this.state,
    required this.title,
    required this.values,
    required this.getDescription,
    this.onPressed,
    this.direction = Axis.horizontal,
    this.initialValue,
  }) : super(key: key);

  @override
  _ToggleFieldState createState() => _ToggleFieldState();
}

class _ToggleFieldState extends State<ToggleField> {
  late List<bool> _selections;

  @override
  void initState() {
    _selections = List.generate(widget.values.length, (index) {
      return widget.values[index] == widget.initialValue;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        SizedBox(
          width: widget.direction == Axis.vertical ? double.infinity : null,
          child: ToggleButtons(
            direction: widget.direction,
            borderRadius: BorderRadius.circular(10.0),
            isSelected: _selections,
            onPressed: (int newIndex) {
              if (widget.onPressed != null) {
                widget.onPressed!(widget.values[newIndex]);
              }
              widget.state?.didChange(widget.values[newIndex]);
              setState(() {
                for (int index = 0; index < _selections.length; index++) {
                  _selections[index] = index == newIndex;
                }
              });
            },
            children: widget.values
                .map<Widget>(
                  (value) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                    ),
                    child:
                        Text(widget.getDescription(value, context) as String),
                  ),
                )
                .toList(),
          ),
        ),
        if (widget.state?.hasError == true)
          Text(
            widget.state?.errorText ?? '',
            style: TextStyle(
              color: Theme.of(context).errorColor,
            ),
          ),
      ],
    );
  }
}

class ToggleFormField<EnumType> extends FormField<EnumType> {
  ToggleFormField({
    Key? key,
    FormFieldSetter<EnumType>? onSaved,
    FormFieldValidator<EnumType>? validator,
    required String title,
    required List values,
    required Function getDescription,
    Function? onPressed,
    Axis direction = Axis.horizontal,
    EnumType? initialValue,
  }) : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<EnumType> state) {
              return ToggleField<EnumType>(
                state: state,
                title: title,
                values: values,
                getDescription: getDescription,
                onPressed: onPressed,
                direction: direction,
                initialValue: initialValue,
              );
            });
}
