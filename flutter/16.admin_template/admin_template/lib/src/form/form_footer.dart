import 'package:admin_template/src/color/shrine.dart';
import 'package:admin_template/src/form/field_panel.dart';
import 'package:flutter/material.dart';

/// An opinion form footer for saving form data.
///
/// Represents a panel at the bottom of an [AgForm]. It usually contains 2 -> 3
/// buttons for saving & cancelling form data.
///
/// TODO: provide more options to customise form actions.
class AgFormFooter extends StatelessWidget {
  final RaisedButton primaryButton;
  final TextButton secondaryButton;
  final TextButton additionalButton;

  /// On saved action is called if [primaryButton] is set as default. Otherwise,
  /// you must manually handle the on saved action when the customized button is
  /// hitted.
  final ValueChanged<void> onSaved;

  const AgFormFooter(
      {Key key,
      this.primaryButton,
      this.secondaryButton,
      this.additionalButton,
      this.onSaved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FieldPanel(
      labelText: '',
      child: Row(
        children: [
          primaryButton ?? _buildPrimaryButton(context),
          const SizedBox(width: 8),
          secondaryButton ?? _buildSecondaryButton(context),
          if (additionalButton != null) additionalButton,
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return RaisedButton(
      child: const Text('Save'),
      onPressed: () {
        final formState = Form.of(context);
        if (formState.validate()) {
          Form.of(context).save();
          if (onSaved != null) onSaved(null);
        }
      },
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return TextButton(
      style: _secondaryButtonStyle,
      child: const Text('Reset'),
      onPressed: () => Form.of(context).reset(),
    );
  }
}

final ButtonStyle _secondaryButtonStyle = TextButton.styleFrom(
  onSurface: shrineBrown900,
);
