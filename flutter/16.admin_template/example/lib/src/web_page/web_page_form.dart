import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'web_page.dart';

class WebPageForm extends StatefulWidget {
  @override
  _WebPageFormState createState() => _WebPageFormState();
}

class _WebPageFormState extends State<WebPageForm> {
  WebPage model;

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
            onWillPop: () {
              print('onWillPop');
              return Future.value(true);
            },
            onChanged: () {
              print('onChanged');
            },
            child: Builder(
              builder: (BuildContext fContext) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      firstPublishedAt,
                      const SizedBox(height: 24),
                      lastPublishedAt,
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
    return InputDatePickerFormField(
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 6)),
      onDateSubmitted: (newValue) {},
      onDateSaved: (newValue) {
        model = model.rebuild((b) => b..firstPublishedAt = newValue);
      },
    );
  }

  Widget get lastPublishedAt {
    return Container();
  }
}
