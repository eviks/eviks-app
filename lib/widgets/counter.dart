import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  final double height;
  final int total;
  final int current;

  const Counter({
    Key? key,
    required this.height,
    required this.total,
    required this.current,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 2.0,
            vertical: 15.0,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                16.0,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              '$current/$total',
            ),
          ),
        ),
      ),
    );
  }
}
