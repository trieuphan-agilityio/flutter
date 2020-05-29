import 'package:admin_template_annotation/admin_template_annotation.dart';
import 'package:flutter/material.dart';

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
        Text(label),
      ],
    );
  }
}

class AgCheckboxListField<T extends ListItem> extends StatefulWidget {
  const AgCheckboxListField({
    Key key,
    @required this.choices,
    @required this.initialValue,
    this.icon,
    this.labelText,
    this.hintText,
    this.helperText,
    this.autovalidate = false,
    this.onChanged,
    this.onSaved,
    this.validator,
  })  : assert(choices != null && choices.length > 0),
        super(key: key);

  final List<T> choices;
  final List<T> initialValue;
  final Widget icon;
  final String labelText;
  final String hintText;
  final String helperText;
  final bool autovalidate;
  final ValueChanged<List<T>> onChanged;
  final FormFieldSetter<List<T>> onSaved;
  final FormFieldValidator<List<T>> validator;

  @override
  _AgCheckboxListFieldState<T> createState() => _AgCheckboxListFieldState<T>();
}

class _AgCheckboxListFieldState<T extends ListItem>
    extends State<AgCheckboxListField<T>> {
  @override
  Widget build(BuildContext context) {
    final control = FormField<List<T>>(
      initialValue: widget.initialValue,
      onSaved: widget.onSaved,
      validator: widget.validator,
      autovalidate: widget.autovalidate,
      builder: (FormFieldState<List<T>> field) {
        void onChangedHandler(List<T> value) {
          if (widget.onChanged != null) {
            widget.onChanged(value);
          }
          field.didChange(value);
        }

        return InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
            helperText: widget.helperText,
            errorText: field.errorText,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...widget.choices.map(
                (T e) => LabeledCheckbox(
                  label: e.name,
                  onChanged: (bool value) {
                    var currentVal = [...field.value];
                    if (value)
                      currentVal.add(e);
                    else
                      currentVal.remove(e);
                    onChangedHandler(currentVal);
                  },
                  value: field.value.contains(e),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (widget.labelText == null) return control;

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
            )),
        SizedBox(width: 16),
        Expanded(child: control),
      ],
    );
  }
}
