import 'package:eviks_mobile/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_preferences.dart';

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
    final bool isDarkMode =
        Provider.of<ThemePreferences>(context, listen: false).themeMode ==
            ThemeMode.dark;
    return Container(
      margin: const EdgeInsets.only(
        top: 8.0,
      ),
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: const LinearGradient(
          colors: [
            lightPrimaryColor,
            darkPrimaryColor,
          ],
        ),
        boxShadow: secondary || !isDarkMode
            ? null
            : [
                BoxShadow(
                  spreadRadius: -1.0,
                  color: Theme.of(context).primaryColor.withOpacity(0.6),
                  blurRadius: 16,
                  blurStyle: BlurStyle.outer,
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (color == null) {
                return !secondary
                    ? Colors.transparent
                    : Theme.of(context).colorScheme.background;
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
                      ? Theme.of(context).colorScheme.background
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
                          ? Theme.of(context).colorScheme.background
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
                          ? Theme.of(context).colorScheme.background
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
