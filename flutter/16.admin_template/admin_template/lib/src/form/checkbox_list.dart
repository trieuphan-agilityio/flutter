import 'package:built_collection/built_collection.dart';
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

class AgCheckboxListField extends StatefulWidget {
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

  final List<String> choices;
  final BuiltList<String> initialValue;
  final Widget icon;
  final String labelText;
  final String hintText;
  final String helperText;
  final bool autovalidate;
  final ValueChanged<BuiltList<String>> onChanged;
  final FormFieldSetter<BuiltList<String>> onSaved;
  final FormFieldValidator<BuiltList<String>> validator;

  @override
  _AgCheckboxListFieldState createState() => _AgCheckboxListFieldState();
}

class _AgCheckboxListFieldState extends State<AgCheckboxListField> {
  @override
  Widget build(BuildContext context) {
    final control = FormField<BuiltList<String>>(
      initialValue: widget.initialValue,
      onSaved: widget.onSaved,
      validator: widget.validator,
      autovalidate: widget.autovalidate,
      builder: (FormFieldState<BuiltList<String>> field) {
        void onChangedHandler(BuiltList<String> value) {
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
                (String value) => LabeledCheckbox(
                  label: value,
                  onChanged: (bool newValue) {
                    var currentVal = BuiltList.of([...field.value]);
                    if (newValue)
                      currentVal = currentVal.rebuild((b) => b.add(value));
                    else
                      currentVal = currentVal.rebuild((b) => b.remove(value));
                    onChangedHandler(currentVal);
                  },
                  value: field.value.contains(value),
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
