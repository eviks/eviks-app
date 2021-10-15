import 'package:flutter/material.dart';

class StyledElevatedButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final bool loading;
  final double? width;
  final bool secondary;

  const StyledElevatedButton(
      {required this.text,
      this.onPressed,
      this.loading = false,
      this.width,
      this.secondary = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 8.0,
      ),
      width: width,
      height: 60.0,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return !secondary
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).backgroundColor;
              } else {
                return !secondary
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).backgroundColor;
              }
            },
          ),
        ),
        child: loading
            ? SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(
                  color: Theme.of(context).backgroundColor,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: !secondary
                      ? Theme.of(context).backgroundColor
                      : Theme.of(context).dividerColor,
                  fontSize: 20.0,
                  fontWeight: !secondary ? FontWeight.bold : null,
                ),
              ),
      ),
    );
  }
}
