import 'package:flutter/material.dart';

class StyledInput extends StatefulWidget {
  final IconData icon;
  final String? title;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final Function(String?)? onChanged;
  final Function(bool)? onFocus;

  const StyledInput({
    Key? key,
    required this.icon,
    this.title,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onFocus,
  }) : super(key: key);

  @override
  _StyledInputState createState() => _StyledInputState();
}

class _StyledInputState extends State<StyledInput> {
  late FocusNode _focus;
  bool _filled = true;

  @override
  void initState() {
    _focus = FocusNode();
    _focus.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  void listener() {
    if (widget.onFocus != null) widget.onFocus!(_focus.hasFocus);
    setState(() {
      _filled = !_focus.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 2.0),
              child: Text(
                widget.title ?? '',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          TextFormField(
            focusNode: _focus,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            controller: widget.controller,
            decoration: InputDecoration(
              prefixIcon: Icon(widget.icon),
              filled: _filled,
            ),
            validator: widget.validator,
            onSaved: widget.onSaved,
            onChanged: widget.onChanged,
          ),
        ],
      ),
    );
  }
}
