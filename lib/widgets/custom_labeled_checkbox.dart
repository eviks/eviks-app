import 'package:flutter/material.dart';

enum CheckboxType {
  parent,
  child,
}

class CustomLabeledCheckbox extends StatelessWidget {
  final String label;
  final bool? value;
  final bool tristate;
  final ValueChanged<bool?> onChanged;
  final CheckboxType checkboxType;
  final Color? activeColor;
  final TextStyle? labelStyle;

  const CustomLabeledCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkboxType = CheckboxType.child,
    this.labelStyle,
  })  : assert(
          (checkboxType == CheckboxType.child && value != null) ||
              (checkboxType == CheckboxType.parent &&
                  (value != null || value == null)),
        ),
        tristate = checkboxType == CheckboxType.parent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onChanged,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 16.0),
        child: Row(
          children: [
            if (checkboxType == CheckboxType.child)
              const SizedBox(width: 32.0)
            else
              const SizedBox(width: 0.0),
            Checkbox(
              tristate: tristate,
              value: value,
              onChanged: (val) {
                _onChanged();
              },
              activeColor: activeColor ?? Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: labelStyle ?? Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
      ),
    );
  }

  void _onChanged() {
    if (value != null) {
      onChanged(!value!);
    } else {
      onChanged(value);
    }
  }
}
