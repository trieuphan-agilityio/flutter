import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ===================================================================
/// Text Field
/// ===================================================================

class AgTextField extends StatefulWidget {
  final TextEditingController controller;
  final String initialValue;
  final Widget icon;
  final String labelText;
  final String hintText;
  final String helperText;
  final String prefixText;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final List<TextInputFormatter> inputFormatters;

  const AgTextField({
    Key key,
    this.controller,
    this.initialValue,
    this.icon,
    this.labelText,
    this.hintText,
    this.helperText,
    this.prefixText,
    this.maxLength,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.inputFormatters,
  }) : super(key: key);

  @override
  _AgTextFieldState createState() => _AgTextFieldState();
}

class _AgTextFieldState extends State<AgTextField> {
  @override
  Widget build(BuildContext context) {
    final inputTheme = Theme.of(context).inputDecorationTheme;
    final decoration = InputDecoration(
      border: inputTheme.border ?? const UnderlineInputBorder(),
      filled: inputTheme.filled ?? true,
      suffixIcon: widget.icon,
      hintText: widget.hintText,
      helperText: widget.helperText,
      prefixText: widget.prefixText,
    );

    final textField = TextFormField(
      onSaved: widget.onSaved,
      initialValue: widget.initialValue,
      decoration: decoration,
      maxLength: widget.maxLength,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
    );

    if (widget.labelText == null) return textField;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            widget.labelText,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 16),
        Expanded(child: textField),
      ],
    );
  }
}

/// ===================================================================
/// Password Field
/// ===================================================================

class AgPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String initialValue;
  final Widget icon;
  final String labelText;
  final String hintText;
  final String helperText;
  final String prefixText;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  const AgPasswordField({
    Key key,
    this.controller,
    this.initialValue,
    this.icon,
    this.labelText,
    this.hintText,
    this.helperText,
    this.prefixText,
    this.maxLength,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  _AgPasswordFieldState createState() => _AgPasswordFieldState();
}

class _AgPasswordFieldState extends State<AgPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final inputTheme = Theme.of(context).inputDecorationTheme;
    final decoration = InputDecoration(
      border: inputTheme.border ?? const UnderlineInputBorder(),
      filled: inputTheme.filled ?? true,
      hintText: widget.hintText,
      helperText: widget.helperText,
      suffixIcon: GestureDetector(
        dragStartBehavior: DragStartBehavior.down,
        onTap: () => setState(() => _obscureText = !_obscureText),
        child: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          semanticLabel: _obscureText ? 'show password' : 'hide password',
        ),
      ),
    );

    final textField = TextFormField(
      onSaved: widget.onSaved,
      initialValue: widget.initialValue,
      decoration: decoration,
      obscureText: _obscureText,
      maxLength: widget.maxLength,
      validator: widget.validator,
      onChanged: widget.onChanged,
    );

    if (widget.labelText == null) return textField;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            widget.labelText,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 16),
        Expanded(child: textField),
      ],
    );
  }

  void toggleViewPassword() {
    setState(() => _obscureText = !_obscureText);
  }
}
