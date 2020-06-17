// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:admin_template_core/core.dart';
import 'package:flutter/material.dart' hide DateTimeRange;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../field_utils.dart' as field_utils;
import 'calendar_date_range_picker.dart';

const double _kDateRangePickerDropdownWidth = 512.0;
const double _kDateRangePickerDropdownHeight = 280.0;

/// Provides a pair of text fields that allow the user to enter the start and
/// end dates that represent a range of dates.
///
/// Note: this is not publicly exported (see pickers.dart), as it is just an
/// internal component used by [showDateRangePicker].
class InputDateRangePicker extends StatefulWidget {
  /// Creates a row with two text fields configured to accept the start and end dates
  /// of a date range.
  InputDateRangePicker({
    Key key,
    @required this.startController,
    @required this.endController,
    @required DateTime firstDate,
    @required DateTime lastDate,
    @required this.onDateRangeChanged,
    this.helpText,
    this.errorFormatText,
    this.errorInvalidText,
    this.errorInvalidRangeText,
    this.fieldStartHintText,
    this.fieldEndHintText,
    this.fieldStartLabelText,
    this.fieldEndLabelText,
    this.autofocus = false,
  })  : assert(firstDate != null),
        firstDate = dateOnly(firstDate),
        assert(lastDate != null),
        lastDate = dateOnly(lastDate),
        assert(firstDate != null),
        assert(lastDate != null),
        assert(autofocus != null),
        super(key: key);

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// Called when the user changes the date range.
  final ValueChanged<DateTimeRange> onDateRangeChanged;

  /// The text that is displayed at the top of the header.
  ///
  /// This is used to indicate to the user what they are selecting a date for.
  final String helpText;

  /// Error text used to indicate the text in a field is not a valid date.
  final String errorFormatText;

  /// Error text used to indicate the date in a field is not in the valid range
  /// of [firstDate] - [lastDate].
  final String errorInvalidText;

  /// Error text used to indicate the dates given don't form a valid date
  /// range (i.e. the start date is after the end date).
  final String errorInvalidRangeText;

  /// Hint text shown when the start date field is empty.
  final String fieldStartHintText;

  /// Hint text shown when the end date field is empty.
  final String fieldEndHintText;

  /// Label used for the start date field.
  final String fieldStartLabelText;

  /// Label used for the end date field.
  final String fieldEndLabelText;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// Controls the text of the end date being edited.
  final TextEditingController startController;

  /// Controls the text of the start date being edited.
  final TextEditingController endController;

  @override
  InputDateRangePickerState createState() => InputDateRangePickerState();
}

/// The current state of an [InputDateRangePicker]. Can be used to
/// [validate] the date field entries.
class InputDateRangePickerState extends State<InputDateRangePicker> {
  DateTime _startDate;
  DateTime _endDate;
  List<TextInputFormatter> _inputFormatters;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localizations = MaterialLocalizations.of(context);
    _inputFormatters = <TextInputFormatter>[
      field_utils.DateTextInputFormatter(localizations.dateSeparator),
    ];
  }

  DateTime _parseDate(String text) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.parseCompactDate(text);
  }

  String _formatDate(DateTime date) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatCompactDate(date);
  }

  void _handleStartChanged(String text) {
    setState(() {
      _startDate = _parseDate(text);
      if (_startDate != null && _endDate != null)
        widget.onDateRangeChanged?.call(DateTimeRange(
          start: _startDate,
          end: _endDate,
        ));
    });
  }

  void _handleEndChanged(String text) {
    setState(() {
      _endDate = _parseDate(text);
      if (_startDate != null && _endDate != null)
        widget.onDateRangeChanged?.call(DateTimeRange(
          start: _startDate,
          end: _endDate,
        ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final inputTheme = Theme.of(context).inputDecorationTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: widget.startController,
            decoration: InputDecoration(
              border: inputTheme.border ?? const UnderlineInputBorder(),
              filled: inputTheme.filled ?? true,
              hintText: widget.fieldStartHintText ?? localizations.dateHelpText,
              labelText: widget.fieldStartLabelText ??
                  localizations.dateRangeStartLabel,
              errorText: widget.errorInvalidRangeText,
              suffixIcon: IconButton(
                icon: Icon(Icons.date_range,
                    semanticLabel: 'open date range picker'),
                onPressed: showDateRangePicker,
              ),
            ),
            inputFormatters: _inputFormatters,
            keyboardType: TextInputType.datetime,
            onChanged: _handleStartChanged,
            autofocus: widget.autofocus,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: widget.endController,
            decoration: InputDecoration(
              border: inputTheme.border ?? const UnderlineInputBorder(),
              filled: inputTheme.filled ?? true,
              hintText: widget.fieldEndHintText ?? localizations.dateHelpText,
              labelText:
                  widget.fieldEndLabelText ?? localizations.dateRangeEndLabel,
              suffixIcon: IconButton(
                icon: Icon(Icons.date_range,
                    semanticLabel: 'open date range picker'),
                onPressed: showDateRangePicker,
              ),
            ),
            inputFormatters: _inputFormatters,
            keyboardType: TextInputType.datetime,
            onChanged: _handleEndChanged,
          ),
        ),
      ],
    );
  }

  /// Find the position to show up the date range picker.
  Future<void> showDateRangePicker() async {
    final RenderBox datePicker = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    // find position of the text field on the coordinate system of the
    // overlay
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        datePicker.localToGlobal(Offset.zero, ancestor: overlay),
        datePicker.localToGlobal(datePicker.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    var initialStartDate = _parseDate(widget.startController.text);
    var initialEndDate = _parseDate(widget.endController.text);

    void resetInitialDateRange() {
      initialStartDate = null;
      initialEndDate = null;
    }

    // reset initial date range if the value is invalid.
    if (initialStartDate != null &&
        initialStartDate.isBefore(widget.firstDate)) {
      resetInitialDateRange();
    } else if (initialEndDate != null &&
        initialEndDate.isAfter(initialEndDate)) {
      resetInitialDateRange();
    } else if (initialStartDate == null || initialEndDate == null) {
      resetInitialDateRange();
    } else {
      initialStartDate = initialStartDate;
      initialEndDate = initialEndDate;
    }

    final selectedDateRange = await _doShowDateRangePicker(
      context: context,
      position: position,
      initialStartDate: initialStartDate,
      initialEndDate: initialEndDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (selectedDateRange == null) return;

    final startText = _formatDate(selectedDateRange.start);
    _handleStartChanged(startText);

    final endText = _formatDate(selectedDateRange.end);
    _handleEndChanged(endText);
  }
}

Future<DateTimeRange> _doShowDateRangePicker({
  @required BuildContext context,
  @required RelativeRect position,
  bool useRootNavigator = false,
  DateTime initialStartDate,
  DateTime initialEndDate,
  DateTime firstDate,
  DateTime lastDate,
}) {
  assert(context != null);
  assert(position != null);
  assert(useRootNavigator != null);

  return Navigator.of(context, rootNavigator: useRootNavigator).push(
    _DateRangePickerDropdownRoute(
      position: position,
      elevation: 2,
      initialStartDate: initialStartDate,
      initialEndDate: initialEndDate,
      firstDate: firstDate,
      lastDate: lastDate,
    ),
  );
}

/// ===================================================================
/// Date Range Picker Route
/// ===================================================================
const Duration _kModalDatePickerDuration = Duration(milliseconds: 300);

class _DateRangePickerDropdownRoute extends PopupRoute<DateTimeRange> {
  _DateRangePickerDropdownRoute({
    this.position,
    this.elevation,
    this.barrierLabel,
    this.initialStartDate,
    this.initialEndDate,
    this.firstDate,
    this.lastDate,
  });

  // Rectangle of underlying text field, relative to the overlay's
  // coordinator system.
  final RelativeRect position;

  final double elevation;
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget picker = _DateRangePickerDropdown(route: this);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(builder: (BuildContext context) {
        return CustomSingleChildLayout(
          delegate: _DatePickerDropdownRouteLayout(position),
          child: picker,
        );
      }),
    );
  }

  @override
  Duration get transitionDuration => _kModalDatePickerDuration;
}

// Positioning of the date picker dropdown on the screen
class _DatePickerDropdownRouteLayout extends SingleChildLayoutDelegate {
  _DatePickerDropdownRouteLayout(this.position);

  // Rectangle of underlying text field, relative to the overlay's dimensions.
  final RelativeRect position;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: _kDateRangePickerDropdownWidth,
      height: _kDateRangePickerDropdownHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the dropdown, when fully open, as determined by
    // getConstraintsForChild.

    // Dropdown is left-aligned with the date text field.
    double x = position.left;

    // Find the vertical position.
    double y = position.top + (size.height - position.top - position.bottom);

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_DatePickerDropdownRouteLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}

class _DateRangePickerDropdown extends StatelessWidget {
  const _DateRangePickerDropdown({Key key, this.route}) : super(key: key);

  final _DateRangePickerDropdownRoute route;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      elevation: route.elevation,
      child: CalendarDateRangePicker(
        initialStartDate: route.initialStartDate,
        initialEndDate: route.initialEndDate,
        firstDate: route.firstDate,
        lastDate: route.lastDate,
        onDateRangeChanged: (newValue) {
          Navigator.of(context).pop(newValue);
        },
      ),
    );
  }
}
