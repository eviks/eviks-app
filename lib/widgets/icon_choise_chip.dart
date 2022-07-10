import 'package:flutter/material.dart';

class IconChoiseChip extends StatelessWidget {
  final IconData? icon;
  final Widget label;
  final bool value;
  final Function(bool)? onSelected;

  const IconChoiseChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      avatar: Icon(
        icon,
        color: value
            ? Theme.of(context).backgroundColor
            : Theme.of(context).chipTheme.labelStyle.color,
      ),
      label: label,
      selected: value,
      onSelected: onSelected,
      elevation: 3.0,
      padding: const EdgeInsets.all(
        16.0,
      ),
      labelPadding: const EdgeInsets.all(
        8.0,
      ),
    );
  }
}
