import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'utils.dart' as utils;

class DatePickerField extends StatefulWidget {
  DatePickerField({
    Key key,
    DateTime initialDate,
    @required DateTime firstDate,
    @required DateTime lastDate,
    this.decoration,
    this.onDateSubmitted,
    this.onDateSaved,
    this.selectableDayPredicate,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.autofocus = false,
  })  : assert(firstDate != null),
        assert(lastDate != null),
        initialDate = initialDate != null ? utils.dateOnly(initialDate) : null,
        firstDate = utils.dateOnly(firstDate),
        lastDate = utils.dateOnly(lastDate),
        super(key: key);

  /// If provided, it will be used as the default value of the field.
  final DateTime initialDate;

  /// The earliest allowable [DateTime] that the user can input.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can input.
  final DateTime lastDate;

  /// The decoration is show around the text field.
  final InputDecoration decoration;

  /// An optional method to call when the user indicates they are done editing
  /// the text in the field. Will only be called if the input represents a valid
  /// [DateTime].
  final ValueChanged<DateTime> onDateSubmitted;

  /// An optional method to call with the final date when the form is
  /// saved via [FormState.save]. Will only be called if the input represents
  /// a valid [DateTime].
  final ValueChanged<DateTime> onDateSaved;

  /// Function to provide full control over which [DateTime] can be selected.
  final SelectableDayPredicate selectableDayPredicate;

  /// The error text displayed if the entered date is not in the correct format.
  final String errorFormatText;

  /// The error text displayed if the date is not valid.
  /// A date is not valid if it is earlier than [firstDate], later than
  /// [lastDate], or doesn't pass the [selectableDayPredicate].
  final String errorInvalidText;

  /// The hint text displayed in the [TextField].
  ///
  /// If this is null, it will default to the date format string. For example,
  /// 'mm/dd/yyyy' for en_US.
  final String fieldHintText;

  /// The label text displayed in the [TextField].
  ///
  /// If this is null, it will default to the words representing the date format
  /// string. For example, 'Month, Day, Year' for en_US.
  final String fieldLabelText;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  final TextEditingController _controller = TextEditingController();
  DateTime _selectedDate;
  String _inputText;
  bool _autoSelected = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  DateTime _parseDate(String text) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.parseCompactDate(text);
  }

  bool _isValidAcceptableDate(DateTime date) {
    return date != null &&
        !date.isBefore(widget.firstDate) &&
        !date.isAfter(widget.lastDate) &&
        (widget.selectableDayPredicate == null ||
            widget.selectableDayPredicate(date));
  }

  String _validateDate(String text) {
    final DateTime date = _parseDate(text);
    if (date == null) {
      return widget.errorFormatText ?? 'Invalid format.';
    } else if (!_isValidAcceptableDate(date)) {
      return widget.errorInvalidText ?? 'Out of range.';
    }
    return null;
  }

  void _handleSaved(String text) {
    if (widget.onDateSaved != null) {
      final DateTime date = _parseDate(text);
      if (_isValidAcceptableDate(date)) {
        _selectedDate = date;
        _inputText = text;
        widget.onDateSaved(date);
      }
    }
  }

  void _handleSubmitted(String text) {
    if (widget.onDateSubmitted != null) {
      final DateTime date = _parseDate(text);
      if (_isValidAcceptableDate(date)) {
        _selectedDate = date;
        _inputText = text;
        widget.onDateSubmitted(date);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final InputDecoration effectiveDecoration =
        (widget.decoration ?? const InputDecoration())
            .applyDefaults(Theme.of(context).inputDecorationTheme);

    return TextFormField(
      decoration: effectiveDecoration.copyWith(
        hintText: widget.fieldHintText ?? 'mm/dd/yyyy',
        labelText: widget.fieldLabelText ?? 'Enter Date',
        suffixIcon: GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onTap: () {
            print('open date picker');
            final RenderBox datePicker =
                context.findRenderObject() as RenderBox;
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;
            final RelativeRect position = RelativeRect.fromRect(
              Rect.fromPoints(
                datePicker.localToGlobal(Offset.zero, ancestor: overlay),
                datePicker.localToGlobal(
                    datePicker.size.bottomRight(Offset.zero),
                    ancestor: overlay),
              ),
              Offset.zero & overlay.size,
            );
            showDatePicker(
              context: context,
              position: position,
            );
          },
          child: Icon(Icons.date_range, semanticLabel: 'open date picker'),
        ),
      ),
      validator: _validateDate,
      inputFormatters: <TextInputFormatter>[
        DateTextInputFormatter('/'),
      ],
      keyboardType: TextInputType.datetime,
      onSaved: _handleSaved,
      onFieldSubmitted: _handleSubmitted,
      autofocus: widget.autofocus,
      controller: _controller,
    );
  }

  Future<DateTime> showDatePicker({
    @required BuildContext context,
    @required RelativeRect position,
    bool useRootNavigator = false,
  }) {
    assert(context != null);
    assert(position != null);
    assert(useRootNavigator != null);

    return Navigator.of(context, rootNavigator: useRootNavigator).push(
      _ModalDatePickerRoute<DateTime>(
        position: position,
        elevation: 1,
        semanticLabel: 'label',
        barrierLabel: '',
        picker: Material(
          type: MaterialType.card,
          elevation: 2,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 280,
            ),
            child: IntrinsicWidth(
              stepWidth: 280,
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                lastDate: DateTime.now().add(Duration(days: 30)),
                onDateChanged: (newValue) {},
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A `TextInputFormatter` set up to format dates.
class DateTextInputFormatter extends TextInputFormatter {
  /// Creates a date formatter with the given separator.
  DateTextInputFormatter(this.separator)
      : _filterFormatter = WhitelistingTextInputFormatter(
            RegExp('[\\d$_commonSeparators\\$separator]+'));

  /// List of common separators that are used in dates. This is used to make
  /// sure that if given platform's [TextInputType.datetime] keyboard doesn't
  /// provide the given locale's separator character, they can still enter the
  /// separator using one of these characters (slash, period, comma, dash, or
  /// space).
  static const String _commonSeparators = r'\/\.,-\s';

  /// The date separator for the current locale
  final String separator;

  // Formatter that will filter out all characters except digits and date
  // separators.
  final WhitelistingTextInputFormatter _filterFormatter;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final TextEditingValue filteredValue =
        _filterFormatter.formatEditUpdate(oldValue, newValue);
    return filteredValue.copyWith(
      // Replace any non-digits with the given separator
      text: filteredValue.text.replaceAll(RegExp(r'[\D]'), separator),
    );
  }
}

/// ===================================================================
/// Popup Route
/// ===================================================================
const Duration _kModalDatePickerDuration = Duration(milliseconds: 300);

class _ModalDatePickerRoute<T> extends PopupRoute<T> {
  _ModalDatePickerRoute({
    this.position,
    this.picker,
    this.elevation,
    this.barrierLabel,
    this.semanticLabel,
  });

  final RelativeRect position;
  final Widget picker;
  final double elevation;
  final String semanticLabel;

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: picker,
    );
  }

  @override
  Duration get transitionDuration => _kModalDatePickerDuration;
}
