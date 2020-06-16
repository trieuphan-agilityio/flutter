import 'package:admin_template_core/core.dart';
import 'package:flutter/material.dart' hide DateTimeRange;
import 'package:flutter/widgets.dart';

import 'input_date_range_picker.dart';

class DateRangePickerField extends FormField<DateTimeRange> {
  DateRangePickerField({
    Key key,
    DateTimeRange initialValue,
    @required DateTime firstDate,
    @required DateTime lastDate,
    this.decoration,
    this.onDateRangeSubmitted,
    this.onDateRangeSaved,
    this.selectableStartDayPredicate,
    this.selectableEndDayPredicate,
    this.errorFormatText,
    this.errorInvalidText,
    this.errorInvalidRangeText,
    this.fieldStartHintText,
    this.fieldEndHintText,
    this.fieldStartLabelText,
    this.fieldEndLabelText,
    this.helperText,
    this.fieldStartPrefixText,
    this.fieldEndPrefixText,
    ValueChanged<DateTimeRange> onChanged,
    FormFieldSetter<DateTimeRange> onSaved,
    FormFieldValidator<DateTimeRange> validator,
    this.autofocus = false,
  })  : assert(firstDate != null),
        assert(lastDate != null),
        initialValue = initialValue != null ? datesOnly(initialValue) : null,
        firstDate = dateOnly(firstDate),
        lastDate = dateOnly(lastDate),
        super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<DateTimeRange> field) {
            final state = field as _DateRangePickerFieldState;
            return InputDateRangePicker(
              startController: state.startController,
              endController: state.endController,
              firstDate: firstDate,
              lastDate: lastDate,
              onDateRangeChanged: state.didChange,
              helpText: helperText,
              errorFormatText: errorFormatText,
              errorInvalidText: errorInvalidText,
              errorInvalidRangeText: state.errorText,
              fieldStartHintText: fieldStartHintText,
              fieldEndHintText: fieldEndHintText,
              fieldStartLabelText: fieldStartLabelText,
              fieldEndLabelText: fieldEndLabelText,
            );
          },
        );

  /// If provided, it will be used as the default value of the field.
  final DateTimeRange initialValue;

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

  /// The helper text displayed in the [TextField]s.
  final String helperText;

  /// The prefix text displayed in the start date [TextField].
  final String fieldStartPrefixText;

  /// The prefix text displayed in the end date [TextField].
  final String fieldEndPrefixText;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  @override
  _DateRangePickerFieldState createState() => _DateRangePickerFieldState();
}

class _DateRangePickerFieldState extends FormFieldState<DateTimeRange> {
  /// Controls the start text being edited
  TextEditingController startController = TextEditingController();

  /// Controls the end text being edited
  TextEditingController endController = TextEditingController();

  @override
  void dispose() {
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localizations = MaterialLocalizations.of(context);
    if (value != null) {
      final _startInputText = localizations.formatCompactDate(value.start);
      _updateController(startController, _startInputText, true);

      final _endInputText = localizations.formatCompactDate(value.end);
      _updateController(endController, _endInputText, false);
    }
  }

  @override
  void didChange(DateTimeRange value) {
    super.didChange(value);
    final startText = _formatDate(value.start);
    final endText = _formatDate(value.end);

    if (startController.text != startText) startController.text = startText;
    if (endController.text != endText) endController.text = endText;
  }

  @override
  void reset() {
    super.reset();
    if (widget.initialValue != null) {
      startController.text = _formatDate(widget.initialValue.start);
      endController.text = _formatDate(widget.initialValue.end);
    }
  }

  @override
  DateRangePickerField get widget => super.widget as DateRangePickerField;

  void _updateController(
    TextEditingController controller,
    String text,
    bool selectText,
  ) {
    TextEditingValue textEditingValue = controller.value.copyWith(text: text);
    if (selectText) {
      textEditingValue = textEditingValue.copyWith(
        selection: TextSelection(baseOffset: 0, extentOffset: text.length),
      );
    }
    controller.value = textEditingValue;
  }

  String _formatDate(DateTime date) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatCompactDate(date);
  }
}
