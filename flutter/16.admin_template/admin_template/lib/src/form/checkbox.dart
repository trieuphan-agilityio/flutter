import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AgCheckboxField extends FormField<bool> {
  final ValueChanged<bool> onFieldSubmitted;
  AgCheckboxField({
    Key key,
    @required bool initialValue,
    Widget icon,
    String labelText,
    String hintText,
    String helperText,
    String prefixText,
    ValueChanged<bool> onChanged,
    FormFieldSetter<bool> onSaved,
    FormFieldValidator<bool> validator,
    ValueChanged<bool> onFieldSubmitted,
  })  : onFieldSubmitted = onFieldSubmitted,
        super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<bool> field) {
            void onChangedHandler(bool value) {
              if (onChanged != null) {
                onChanged(value);
              }
              field.didChange(value);
            }

            final textTheme = Theme.of(field.context).textTheme;

            final control = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: field.value,
                  onChanged: onChangedHandler,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                Text(helperText, style: textTheme.caption),
              ],
            );

            if (labelText == null) return control;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    labelText,
                    style: textTheme.subtitle2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(child: control),
              ],
            );
          },
        );
}
