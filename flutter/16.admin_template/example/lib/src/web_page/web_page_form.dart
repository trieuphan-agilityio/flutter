import 'package:admin_template/admin_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'web_page.dart';

class WebPageCreatingForm extends StatefulWidget {
  final WebPage initialModel;

  /// An optional method to call with the final value when the form is saved.
  final FormFieldSetter<WebPage> onSaved;

  const WebPageCreatingForm({Key key, this.initialModel, this.onSaved})
      : super(key: key);

  @override
  _WebPageCreatingFormState createState() => _WebPageCreatingFormState();
}

class _WebPageCreatingFormState extends State<WebPageCreatingForm> {
  WebPage model;

  @override
  void initState() {
    super.initState();
    model = widget.initialModel;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 80),
        constraints: BoxConstraints.expand(width: 800),
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            // Pressing enter on the field will now move to the next field.
            LogicalKeySet(LogicalKeyboardKey.enter): NextFocusIntent(),
          },
          child: FocusTraversalGroup(
            child: Form(
              autovalidate: false,
              child: Builder(
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title,
                        const SizedBox(height: 24),
                        slug,
                        const SizedBox(height: 24),
                        firstPublishedAt,
                        const SizedBox(height: 24),
                        publishDateRange,
                        const SizedBox(height: 24),
                        Row(children: [
                          MaterialButton(
                            color: Theme.of(context).buttonColor,
                            child: Text('Save'),
                            onPressed: () {
                              final formState = Form.of(context);
                              if (formState.validate()) {
                                Form.of(context).save();
                                widget.onSaved(model);
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          FlatButton(
                            child: Text('Reset'),
                            onPressed: () {
                              Form.of(context).reset();
                            },
                          ),
                          const SizedBox(width: 8),
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {},
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
      ),
    ]);
  }

  Widget get title {
    return AgTextField(
      initialValue: model.title,
      labelText: 'Title',
      helperText: 'The page title as you\'d like to be seen by the public',
      onSaved: (newValue) {
        model = model.rebuild((b) => b.title = newValue);
      },
    );
  }

  Widget get slug {
    return AgTextField(
      initialValue: model.slug,
      labelText: 'Slug',
      helperText: 'Name of the page as it will appear in URLs'
          'e.g http://domain.com/blog/[my-slug]/',
      onSaved: (newValue) {
        model = model.rebuild((b) => b.slug = newValue);
      },
    );
  }

  Widget get firstPublishedAt {
    return DatePickerField(
      labelText: 'First published at',
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
      labelText: 'Publish Date Range',
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
