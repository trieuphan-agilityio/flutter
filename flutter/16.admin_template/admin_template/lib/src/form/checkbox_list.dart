import 'package:flutter/material.dart';

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    this.label,
    this.value,
    this.onChanged,
  });

  final String label;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: value,
          onChanged: (bool newValue) {
            onChanged(newValue);
          },
        ),
        Text(label),
      ],
    );
  }
}

class AgCheckboxListField extends StatefulWidget {
  @override
  _AgCheckboxListFieldState createState() => _AgCheckboxListFieldState();
}

class _AgCheckboxListFieldState extends State<AgCheckboxListField> {
  String labelText;

  @override
  void initState() {
    super.initState();
    labelText = 'Groups';
  }

  @override
  Widget build(BuildContext context) {
    final control = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledCheckbox(
          label: 'Moderator',
          onChanged: (bool value) {},
          value: true,
        ),
        LabeledCheckbox(
          label: 'Editor',
          onChanged: (bool value) {},
          value: true,
        ),
        Text(
          'helperText',
          style: Theme.of(context).textTheme.caption,
        ),
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
