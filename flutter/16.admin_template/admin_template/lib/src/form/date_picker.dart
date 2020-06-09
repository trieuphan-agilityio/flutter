import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'date_utils.dart' as utils;

const double _kDatePickerDropdownWidth = 256.0;
const double _kDatePickerDropdownHeight = 280.0;

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
    this.labelText,
    this.hintText,
    this.helperText,
    this.prefixText,
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_selectedDate != null) {
      _inputText = _formatDate(_selectedDate);
      TextEditingValue textEditingValue =
          _controller.value.copyWith(text: _inputText);
      // Select the new text if we are auto focused and haven't selected the text before.
      if (widget.autofocus && !_autoSelected) {
        textEditingValue = textEditingValue.copyWith(
          selection: TextSelection(
            baseOffset: 0,
            extentOffset: _inputText.length,
          ),
        );
        _autoSelected = true;
      }
      _controller.value = textEditingValue;
    }
  }

  DateTime _parseDate(String text) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.parseCompactDate(text);
  }

  String _formatDate(DateTime date) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.formatCompactDate(date);
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
      return widget.errorFormatText ??
          MaterialLocalizations.of(context).invalidDateFormatLabel;
    } else if (!_isValidAcceptableDate(date)) {
      return widget.errorInvalidText ??
          MaterialLocalizations.of(context).dateOutOfRangeLabel;
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
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final InputDecoration effectiveDecoration =
        (widget.decoration ?? const InputDecoration())
            .applyDefaults(Theme.of(context).inputDecorationTheme);

    return TextFormField(
      decoration: effectiveDecoration.copyWith(
        hintText: widget.hintText ?? localizations.dateHelpText,
        labelText: widget.labelText ?? localizations.dateInputLabel,
        helperText: widget.helperText,
        suffixIcon: IconButton(
          icon: Icon(Icons.date_range, semanticLabel: 'open date picker'),
          onPressed: () async {
            final RenderBox datePicker =
                context.findRenderObject() as RenderBox;
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;

            // find position of the text field on the coordinate system of the
            // overlay
            final RelativeRect position = RelativeRect.fromRect(
              Rect.fromPoints(
                datePicker.localToGlobal(Offset.zero, ancestor: overlay),
                datePicker.localToGlobal(
                    datePicker.size.bottomRight(Offset.zero),
                    ancestor: overlay),
              ),
              Offset.zero & overlay.size,
            );

            final pickedDate = await showDatePicker(
              context: context,
              position: position,
              initialDate: widget.initialDate,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
            );

            if (_isValidAcceptableDate(pickedDate)) {
              _selectedDate = pickedDate;
              _inputText = _formatDate(pickedDate);
              _controller.text = _inputText;
              widget.onDateSaved(pickedDate);
            }
          },
        ),
      ),
      validator: _validateDate,
      inputFormatters: <TextInputFormatter>[
        DateTextInputFormatter(localizations.dateSeparator),
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
    DateTime initialDate,
    DateTime firstDate,
    DateTime lastDate,
  }) {
    assert(context != null);
    assert(position != null);
    assert(useRootNavigator != null);

    return Navigator.of(context, rootNavigator: useRootNavigator).push(
      _DatePickerDropdownRoute(
        position: position,
        elevation: 2,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
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
/// Date Picker Route
/// ===================================================================
const Duration _kModalDatePickerDuration = Duration(milliseconds: 300);

class _DatePickerDropdownRoute extends PopupRoute<DateTime> {
  _DatePickerDropdownRoute({
    this.position,
    this.elevation,
    this.barrierLabel,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  // Rectangle of underlying text field, relative to the overlay's
  // coordinator system.
  final RelativeRect position;

  final double elevation;
  final DateTime initialDate;
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
    Widget picker = _DatePickerDropdown(route: this);

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
      width: _kDatePickerDropdownWidth,
      height: _kDatePickerDropdownHeight,
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

class _DatePickerDropdown extends StatelessWidget {
  const _DatePickerDropdown({Key key, this.route}) : super(key: key);

  final _DatePickerDropdownRoute route;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      elevation: route.elevation,
      child: CalendarDatePicker(
        initialDate: route.initialDate ?? DateTime.now(),
        firstDate: route.firstDate,
        lastDate: route.lastDate,
        onDateChanged: (newValue) {
          Navigator.of(context).pop(newValue);
        },
      ),
    );
  }
}
