import 'package:admin_template/admin_template.dart';
import 'package:flutter/material.dart';

/// Demo Form Field Widgets.
class WebPageDemo extends StatefulWidget {
  final WillPopCallback onWillPop;
  final VoidCallback onChanged;
  final ValueChanged onSaved;

  const WebPageDemo({Key key, this.onWillPop, this.onChanged, this.onSaved})
      : super(key: key);

  @override
  _WebPageDemoState createState() => _WebPageDemoState();
}

class _WebPageDemoState extends State<WebPageDemo> {
  @override
  Widget build(BuildContext context) {
    return AgScaffold(
      header: AgHeader(
        icon: const Icon(Icons.group),
        title: const Text('New User'),
      ),
      body: AgForm(
        fields: [
          AgTextField(
              helperText:
                  'The page title as you would like to be seen by the public',
              labelText: 'Title'),
          AgTextField(
              labelText: 'Slug',
              helperText: 'Name of the page, appear in URLs'
                  ' e.g http://demo.io/blog/[my-slug]/'),
          DatePickerField(
              labelText: 'First published at',
              firstDate: DateTime.now().subtract(Duration(days: 7)),
              lastDate: DateTime.now().add(Duration(days: 30))),
          DateRangePickerField(
              labelText: 'Publish Date Range',
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 90)),
              validator: Validator.dateRange(
                property: 'publishDateRange',
                start: DateTime.now(),
                end: DateTime.now().add(Duration(days: 90)),
                additionalValidator:
                    RequiredValidator(property: 'publishDateRange'),
              )),
        ],
        footer: AgFormFooter(),
      ),
    );
  }
}
