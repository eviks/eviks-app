import 'package:flutter/material.dart';

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
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            return Theme.of(context).primaryColor;
          },
        ),
        elevation: WidgetStateProperty.resolveWith<double?>(
          (Set<WidgetState> states) {
            return 0.0;
          },
        ),
        shape: WidgetStateProperty.resolveWith<OutlinedBorder?>(
          (Set<WidgetState> states) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            );
          },
        ),
      ),
    );
  }
}
