import 'package:admin_template/admin_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'web_page.dart';

class WebPageForm extends StatefulWidget {
  final WebPage model;

  const WebPageForm(this.model, {Key key}) : super(key: key);

  @override
  _WebPageFormState createState() => _WebPageFormState();
}

class _WebPageFormState extends State<WebPageForm> {
  WebPage model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      width: 800,
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          // Pressing enter on the field will now move to the next field.
          LogicalKeySet(LogicalKeyboardKey.enter): NextFocusIntent(),
        },
        child: FocusTraversalGroup(
          child: Form(
            autovalidate: false,
            child: Builder(
              builder: (BuildContext fContext) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      firstPublishedAt,
                      const SizedBox(height: 24),
                      publishDateRange,
                      const SizedBox(height: 24),
                      Row(children: [
                        RaisedButton(
                          color: Theme.of(context).buttonColor,
                          child: Text('Save'),
                          onPressed: () {
                            final formState = Form.of(fContext);
                            if (formState.validate()) {
                              Form.of(fContext).save();
                              onSaved(model);
                            }
                          },
                        ),
                        RaisedButton(
                          child: Text('Reset'),
                          onPressed: () {
                            Form.of(fContext).reset();
                          },
                        ),
                        RaisedButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            print('Cancel');
                          },
                        ),
                      ]),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  onSaved(WebPage newValue) {
    print(newValue);
  }

  Widget get firstPublishedAt {
    return DatePickerField(
      initialDate: model.firstPublishedAt,
      firstDate: DateTime.now().subtract(Duration(days: 7)),
      lastDate: DateTime.now().add(Duration(days: 30)),
      onDateSaved: (newValue) {
        model = model.rebuild((b) => b..firstPublishedAt = newValue);
      },
    );
  }

  Widget get publishDateRange {
    return DateRangePickerField(
      initialValue: model.publishDateRange,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
      validator: Validator.dateRange(
        property: 'publishDateRange',
        start: DateTime.now(),
        end: DateTime.now().add(Duration(days: 90)),
        additionalValidator: RequiredValidator(property: 'publishDateRange'),
      ),
      onSaved: (newValue) {
        model = model.rebuild((b) => b..publishDateRange = newValue);
      },
    );
  }
}
