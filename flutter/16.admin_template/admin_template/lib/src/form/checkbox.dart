import 'package:admin_template/src/form/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'field_panel.dart';

class AgCheckboxField extends FormField<bool> {
  AgCheckboxField({
    Key key,
    bool initialValue = false,
    Widget icon,
    String labelText,
    String hintText,
    String helperText,
    String prefixText,
    ValueChanged<bool> onChanged,
    FormFieldSetter<bool> onSaved,
    FormFieldValidator<bool> validator,
  }) : super(
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

            final theme = Theme.of(field.context);
            final textTheme = theme.textTheme;
            final helperStyle = textTheme.caption.copyWith(
              color: theme.hintColor,
            );
            final errorStyle = textTheme.caption.copyWith(
              color: theme.errorColor,
            );

            final Widget helperError = HelperError(
              helperText: helperText,
              helperStyle: helperStyle,
              errorText: field.errorText,
              errorStyle: errorStyle,
            );

            return FieldPanel(
              labelText: labelText,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: field.value,
                    onChanged: onChangedHandler,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  helperError,
                ],
              ),
            );
          },
        );
}
