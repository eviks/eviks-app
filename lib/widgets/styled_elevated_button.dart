import 'package:flutter/material.dart';

class StyledElevatedButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final bool loading;
  final double? width;
  final bool secondary;
  final IconData? suffixIcon;
  final double height;
  final Color? color;

  const StyledElevatedButton({
    required this.text,
    this.onPressed,
    this.loading = false,
    this.width,
    this.secondary = false,
    this.suffixIcon,
    this.height = 60.0,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 8.0,
      ),
      width: width,
      height: height,
      color: Colors.transparent,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (color == null) {
                return !secondary
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).backgroundColor;
              } else {
                return color!;
              }
            },
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          elevation: MaterialStateProperty.all<double>(0.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(
                  color: !secondary
                      ? Theme.of(context).backgroundColor
                      : Theme.of(context).primaryColor,
                ),
              )
            else
              Row(
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: !secondary
                          ? Theme.of(context).backgroundColor
                          : Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: !secondary ? FontWeight.bold : null,
                    ),
                  ),
                  if (suffixIcon != null)
                    const SizedBox(
                      width: 8.0,
                    ),
                  if (suffixIcon != null)
                    Icon(
                      suffixIcon,
                      color: !secondary
                          ? Theme.of(context).backgroundColor
                          : Theme.of(context).primaryColor,
                    )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
