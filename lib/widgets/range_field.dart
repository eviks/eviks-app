import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './styled_input.dart';

class RangeField extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? initialValueFrom;
  final String? initialValueTo;
  final TextInputType? keyboardTypeFrom;
  final TextInputType? keyboardTypeTo;
  final TextEditingController? controllerFrom;
  final TextEditingController? controllerTo;
  final String? Function(String?)? validatorFrom;
  final String? Function(String?)? validatorTo;
  final Function(String?)? onSavedFrom;
  final Function(String?)? onSavedTo;
  final Function(String?)? onChangedTo;
  final Function(String?)? onChangedFrom;
  final List<TextInputFormatter>? inputFormattersFrom;
  final List<TextInputFormatter>? inputFormattersTo;

  const RangeField(
      {this.icon,
      this.title,
      this.initialValueFrom,
      this.initialValueTo,
      this.keyboardTypeFrom,
      this.keyboardTypeTo,
      this.controllerFrom,
      this.controllerTo,
      this.validatorFrom,
      this.validatorTo,
      this.onSavedFrom,
      this.onSavedTo,
      this.onChangedFrom,
      this.onChangedTo,
      this.inputFormattersFrom,
      this.inputFormattersTo,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: SizedBox(
            child: StyledInput(
              icon: icon,
              title: title,
              initialValue: initialValueFrom,
              keyboardType: keyboardTypeFrom,
              controller: controllerFrom,
              inputFormatters: inputFormattersFrom,
              validator: validatorFrom,
              onSaved: onSavedFrom,
              onChanged: onChangedFrom,
              hintText: AppLocalizations.of(context)!.valueFrom,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 40.0,
          ),
          child: Text(' - '),
        ),
        Expanded(
          child: SizedBox(
            child: StyledInput(
              title: '',
              initialValue: initialValueTo,
              keyboardType: keyboardTypeTo,
              controller: controllerTo,
              inputFormatters: inputFormattersTo,
              validator: validatorTo,
              onSaved: onSavedTo,
              onChanged: onChangedTo,
              hintText: AppLocalizations.of(context)!.valueTo,
            ),
          ),
        ),
      ],
    );
  }
}
