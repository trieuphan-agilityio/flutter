import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AgCheckboxField extends FormField<bool> {
  AgCheckboxField({
    Key key,
    @required bool initialValue,
    Widget icon,
    String labelText,
    String hintText,
    String helperText,
    String prefixText,
    FormFieldSetter<bool> onSaved,
    FormFieldValidator<bool> validator,
    ValueChanged<bool> onFieldSubmitted,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<bool> field) {
            final _AgCheckboxFieldState state = field as _AgCheckboxFieldState;
            return Column(
              children: [
                GestureDetector(
                  dragStartBehavior: DragStartBehavior.down,
                  onTap: state.toggle,
                  child: Checkbox(
                    value: state._value,
                    onChanged: onFieldSubmitted,
                  ),
                ),
                Text(
                  helperText,
                  style: Theme.of(field.context).textTheme.caption,
                ),
              ],
            );
          },
        );

  @override
  FormFieldState<bool> createState() => _AgCheckboxFieldState();
}

class _AgCheckboxFieldState extends FormFieldState<bool> {
  bool _value;

  @override
  void initState() {
    super.initState();
    _value = value;
  }

  void toggle() {
    setState(() => _value = !_value);
  }
}
