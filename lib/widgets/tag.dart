import 'package:flutter/material.dart';

import '../constants.dart';

class Tag extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Function()? onPressed;

  const Tag({
    required this.label,
    this.icon,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: darken(
          Theme.of(context).dividerColor,
          0.2,
        ),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: darken(
            Theme.of(context).dividerColor,
            0.2,
          ),
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return darken(
              Theme.of(context).backgroundColor,
            );
          },
        ),
        elevation: MaterialStateProperty.resolveWith<double?>(
          (Set<MaterialState> states) {
            return 0.0;
          },
        ),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
          (Set<MaterialState> states) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            );
          },
        ),
      ),
    );
  }
}
