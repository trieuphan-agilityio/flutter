import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ===================================================================
/// Text Field
/// ===================================================================

class AgTextField extends StatefulWidget {
  final String initialValue;
  final Widget icon;
  final String hintText;
  final String helperText;
  final String prefixText;
  final String labelText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final List<TextInputFormatter> inputFormatters;

  const AgTextField({
    Key key,
    this.initialValue,
    this.icon,
    this.hintText,
    this.helperText,
    this.prefixText,
    this.labelText,
    this.onSaved,
    this.validator,
    this.inputFormatters,
  }) : super(key: key);

  @override
  _AgTextFieldState createState() => _AgTextFieldState();
}

class _AgTextFieldState extends State<AgTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        filled: true,
        suffixIcon: widget.icon,
        hintText: widget.hintText,
        helperText: widget.helperText,
        prefixText: widget.prefixText,
        labelText: widget.labelText,
      ),
      onSaved: widget.onSaved,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
    );
  }
}

/// ===================================================================
/// Password Field
/// ===================================================================

class AgPasswordField extends StatefulWidget {
  const AgPasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _AgPasswordFieldState createState() => _AgPasswordFieldState();
}

class _AgPasswordFieldState extends State<AgPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      maxLength: 8,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            semanticLabel: _obscureText ? 'show password' : 'hide password',
          ),
        ),
      ),
    );
  }
}
