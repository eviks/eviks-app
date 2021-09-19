import 'package:flutter/material.dart';

class StepTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const StepTitle({Key? key, required this.title, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(width: 2, color: Theme.of(context).primaryColor),
          ),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).backgroundColor,
            ),
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 24.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
