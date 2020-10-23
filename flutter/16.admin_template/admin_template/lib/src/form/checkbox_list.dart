import 'package:admin_template_core/core.dart';
import 'package:admin_template/src/form/utils.dart';
import 'package:flutter/material.dart';

import 'field_panel.dart';

/// A checkbox widget that is decorated with a label.
class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    Key key,
    @required this.value,
    this.tristate = false,
    this.label,
    this.onChanged,
  })  : assert(tristate != null),
        assert(tristate || value != null),
        super(key: key);

  final String label;

  /// Whether this checkbox is checked.
  final bool value;

  /// If true the checkbox's [value] can be true, false, or null.
  ///
  /// Checkbox displays a dash when its value is null.
  final bool tristate;

  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Checkbox(
          value: value,
          tristate: tristate,
          onChanged: onChanged,
        ),
        Text(label.toTitleCase(), style: Theme.of(context).textTheme.subtitle1),
      ],
    );
  }
}

class AgCheckboxListField<T> extends StatefulWidget {
  const AgCheckboxListField({
    Key key,
    @required this.choices,
    @required this.initialValue,
    @required this.stringify,
    this.icon,
    this.labelText,
    this.hintText,
    this.helperText,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.onSaved,
    this.validator,
  })  : assert(choices != null && choices.length > 0),
        super(key: key);

  final Iterable<T> choices;
  final Iterable<T> initialValue;
  final String Function(T) stringify;
  final Widget icon;
  final String labelText;
  final String hintText;
  final String helperText;
  final AutovalidateMode autovalidateMode;
  final ValueChanged<Iterable<T>> onChanged;
  final FormFieldSetter<Iterable<T>> onSaved;
  final FormFieldValidator<Iterable<T>> validator;

  @override
  _AgCheckboxListFieldState<T> createState() => _AgCheckboxListFieldState();
}

class _AgCheckboxListFieldState<T> extends State<AgCheckboxListField<T>> {
  @override
  Widget build(BuildContext context) {
    final control = FormField<Iterable<T>>(
      initialValue: widget.initialValue,
      onSaved: widget.onSaved,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      builder: (FormFieldState<Iterable<T>> field) {
        void onChangedHandler(Iterable<T> value) {
          if (widget.onChanged != null) {
            widget.onChanged(value);
          }
          field.didChange(value);
        }

        final theme = Theme.of(field.context);
        final textTheme = theme.textTheme;
        final helperStyle = textTheme.caption.copyWith(
          color: theme.hintColor,
        );
        final errorStyle = textTheme.caption.copyWith(
          color: theme.errorColor,
        );

        final Widget helperError = HelperError(
          helperText: widget.helperText,
          helperStyle: helperStyle,
          errorText: field.errorText,
          errorStyle: errorStyle,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...widget.choices.map(
              (T value) => LabeledCheckbox(
                label: widget.stringify(value),
                onChanged: (bool newValue) {
                  var currentVal = [...field.value];
                  if (newValue)
                    currentVal.add(value);
                  else
                    currentVal.remove(value);
                  onChangedHandler(currentVal);
                },
                value: field.value.contains(value),
              ),
            ),
            helperError,
          ],
        );
      },
    );

    return FieldPanel(labelText: widget.labelText, child: control);
  }
}
