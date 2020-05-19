import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ===================================================================
/// Text Field
/// ===================================================================

class AgTextField extends FormField<String> {
  AgTextField({
    Key key,
    String initialValue,
    Widget icon,
    String labelText,
    String hintText,
    String helperText,
    String prefixText,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    ValueChanged<String> onFieldSubmitted,
    List<TextInputFormatter> inputFormatters,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<String> field) {
            final effectiveDecoration = InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              suffixIcon: icon,
              hintText: hintText,
              helperText: helperText,
              prefixText: prefixText,
            ).applyDefaults(Theme.of(field.context).inputDecorationTheme);

            final textField = TextField(
              decoration:
                  effectiveDecoration.copyWith(errorText: field.errorText),
              inputFormatters: inputFormatters,
              onSubmitted: onFieldSubmitted,
            );

            if (labelText == null) return textField;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 150,
                    child: Text(
                      labelText,
                      style: Theme.of(field.context)
                          .textTheme
                          .subtitle2
                          .copyWith(fontWeight: FontWeight.bold),
                    )),
                SizedBox(width: 16),
                Expanded(child: textField),
              ],
            );
          },
        );
}

/// ===================================================================
/// Password Field
/// ===================================================================

class AgPasswordField extends FormField<String> {
  AgPasswordField({
    Key key,
    String labelText,
    String hintText,
    String helperText,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    ValueChanged<String> onFieldSubmitted,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          builder: (FormFieldState<String> field) {
            final _AgPasswordFieldState state = field as _AgPasswordFieldState;
            final effectiveDecoration = InputDecoration(
              border: OutlineInputBorder(),
              hintText: hintText,
              helperText: helperText,
              suffixIcon: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: state.toggleViewPassword,
                child: Icon(
                  state._obscureText ? Icons.visibility : Icons.visibility_off,
                  semanticLabel:
                      state._obscureText ? 'show password' : 'hide password',
                ),
              ),
            );

            final textField = TextField(
              obscureText: state._obscureText,
              decoration:
                  effectiveDecoration.copyWith(errorText: field.errorText),
              onSubmitted: onFieldSubmitted,
            );

            if (labelText == null) return textField;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 150,
                    child: Text(
                      labelText,
                      style: Theme.of(field.context)
                          .textTheme
                          .subtitle2
                          .copyWith(fontWeight: FontWeight.bold),
                    )),
                SizedBox(width: 16),
                Expanded(child: textField),
              ],
            );
          },
        );

  @override
  FormFieldState<String> createState() => _AgPasswordFieldState();
}

class _AgPasswordFieldState extends FormFieldState<String> {
  bool _obscureText = true;

  void toggleViewPassword() {
    setState(() => _obscureText = !_obscureText);
  }
}
