import 'package:flutter/widgets.dart';

/// An abstract class providing sensible default behaviours for objects implementing
/// the EditHandler API
abstract class EditHandler extends StatelessWidget {
  final String heading;

  final String theme;

  final String helpText;

  /// ?
  final String model;

  /// ?
  final String instance;

  /// ?
  final String request;

  /// ?
  final String form;

  EditHandler({
    this.heading = '',
    this.theme = '',
    this.helpText = '',
    this.model,
    this.instance,
    this.request,
    this.form,
  });

  /// return list of widget override that this EditHandler wants to be in place
  /// on the form it receives
  Map<String, Widget> widgetOverrides() {
    return {};
  }
}
