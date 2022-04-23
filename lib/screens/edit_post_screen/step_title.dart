import 'package:flutter/material.dart';

class StepTitle extends StatelessWidget {
  final String title;

  const StepTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 8.0,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 24.0,
              color: Theme.of(context).appBarTheme.titleTextStyle?.color,
            ),
          ),
        ],
      ),
    );
  }
}
