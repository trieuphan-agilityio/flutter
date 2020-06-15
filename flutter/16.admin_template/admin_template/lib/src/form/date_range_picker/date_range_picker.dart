import 'package:admin_template_core/core.dart';
import 'package:flutter/material.dart' hide DateTimeRange;
import 'package:flutter/widgets.dart';

import 'input_date_range_picker.dart';

const double _kDateRangePickerDropdownWidth = 512.0;
const double _kDateRangePickerDropdownHeight = 280.0;

class DateRangePickerField extends StatefulWidget {
  DateRangePickerField({
    Key key,
    DateTimeRange initialDateRange,
    @required DateTime firstDate,
    @required DateTime lastDate,
    this.decoration,
    this.onDateRangeSubmitted,
    this.onDateRangeSaved,
    this.selectableStartDayPredicate,
    this.selectableEndDayPredicate,
    this.errorFormatText,
    this.errorInvalidText,
    this.labelText,
    this.hintText,
    this.helperText,
    this.prefixText,
    this.autofocus = false,
  })  : assert(firstDate != null),
        assert(lastDate != null),
        initialDateRange =
            initialDateRange != null ? datesOnly(initialDateRange) : null,
        firstDate = dateOnly(firstDate),
        lastDate = dateOnly(lastDate),
        super(key: key);

  /// If provided, it will be used as the default value of the field.
  final DateTimeRange initialDateRange;

  /// The earliest allowable [DateTime] that the user can input.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can input.
  final DateTime lastDate;

  /// The decoration is show around the text field.
  final InputDecoration decoration;

  /// An optional method to call when the user indicates they are done editing
  /// the text in the field. Will only be called if the input represents a valid
  /// [DateTimeRange].
  final ValueChanged<DateTimeRange> onDateRangeSubmitted;

  /// An optional method to call with the final date when the form is
  /// saved via [FormState.save]. Will only be called if the input represents
  /// a valid [DateTime].
  final ValueChanged<DateTimeRange> onDateRangeSaved;

  /// Function to provide full control over which start [DateTime] can be selected.
  final SelectableDayPredicate selectableStartDayPredicate;

  /// Function to provide full control over which end [DateTime] can be selected.
  final SelectableDayPredicate selectableEndDayPredicate;

  /// The error text displayed if the entered date is not in the correct format.
  final String errorFormatText;

  /// The error text displayed if the date is not valid.
  /// A date is not valid if it is earlier than [firstDate], later than
  /// [lastDate], or doesn't pass the [selectableDayPredicate].
  final String errorInvalidText;

  /// The label text displayed in the [TextField].
  ///
  /// If this is null, it will default to the words representing the date format
  /// string. For example, 'Month, Day, Year' for en_US.
  final String labelText;

  /// The hint text displayed in the [TextField].
  ///
  /// If this is null, it will default to the date format string. For example,
  /// 'mm/dd/yyyy' for en_US.
  final String hintText;

  /// The helper text displayed in the [TextField].
  final String helperText;

  /// The prefix text displayed in the [TextField].
  final String prefixText;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  @override
  _DateRangePickerFieldState createState() => _DateRangePickerFieldState();
}

class _DateRangePickerFieldState extends State<DateRangePickerField> {
  DateTime startDate;
  DateTime endDate;

  @override
  void initState() {
    if (widget.initialDateRange != null) {
      startDate = widget.initialDateRange.start;
      endDate = widget.initialDateRange.end;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InputDateRangePicker(
      initialStartDate: startDate,
      initialEndDate: endDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      onStartDateChanged: (DateTime value) {
        startDate = value;
        if (startDate != null && endDate != null) {
          setState(() {});
          widget.onDateRangeSaved(DateTimeRange(
            start: startDate,
            end: endDate,
          ));
        }
      },
      onEndDateChanged: (DateTime value) {
        endDate = value;
        if (startDate != null && endDate != null) {
          setState(() {});
          widget.onDateRangeSaved(DateTimeRange(
            start: startDate,
            end: endDate,
          ));
        }
      },
    );
  }
}
