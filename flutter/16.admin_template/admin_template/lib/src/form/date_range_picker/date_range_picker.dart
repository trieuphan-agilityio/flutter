import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../date_utils.dart' as utils;
import 'calendar_date_range_picker.dart';

const double _kDateRangePickerDropdownWidth = 512.0;
const double _kDateRangePickerDropdownHeight = 280.0;

class DateRangePickerField extends StatefulWidget {
  DateRangePickerField({
    Key key,
    DateTimeRange initialDateRange,
    @required DateTime firstDate,
    @required DateTime lastDate,
    this.decoration,
    this.onDateSubmitted,
    this.onDateSaved,
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
            initialDateRange != null ? utils.datesOnly(initialDateRange) : null,
        firstDate = utils.dateOnly(firstDate),
        lastDate = utils.dateOnly(lastDate),
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
  final ValueChanged<DateTimeRange> onDateSubmitted;

  /// An optional method to call with the final date when the form is
  /// saved via [FormState.save]. Will only be called if the input represents
  /// a valid [DateTime].
  final ValueChanged<DateTimeRange> onDateSaved;

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
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: () {
          showDateRangePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 356)),
          );
        },
      ),
      VerticalDivider(thickness: 1.0),
      IconButton(
        icon: Icon(Icons.date_range),
        onPressed: () {
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

          showDatePicker(
            context: context,
            position: position,
            initialDateRange: widget.initialDateRange,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
          );
        },
      ),
    ]);
  }

  Future<DateTimeRange> showDatePicker({
    @required BuildContext context,
    @required RelativeRect position,
    bool useRootNavigator = false,
    @required DateTimeRange initialDateRange,
    @required DateTime firstDate,
    @required DateTime lastDate,
  }) {
    assert(context != null);
    assert(position != null);
    assert(useRootNavigator != null);

    return Navigator.of(context, rootNavigator: useRootNavigator).push(
      _DateRangePickerDropdownRoute(
        position: position,
        elevation: 2,
        initialDateRange: initialDateRange,
        firstDate: firstDate,
        lastDate: lastDate,
      ),
    );
  }
}

/// ===================================================================
/// Date Picker Route
/// ===================================================================
const Duration _kModalDateRangePickerDuration = Duration(milliseconds: 300);

class _DateRangePickerDropdownRoute extends PopupRoute<DateTimeRange> {
  _DateRangePickerDropdownRoute({
    @required this.initialDateRange,
    @required this.firstDate,
    @required this.lastDate,
    this.position,
    this.elevation,
    this.barrierLabel,
  });

  // Rectangle of underlying text field, relative to the overlay's
  // coordinator system.
  final RelativeRect position;

  final double elevation;
  final DateTimeRange initialDateRange;
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
          delegate: _DateRangePickerDropdownRouteLayout(position),
          child: picker,
        );
      }),
    );
  }

  @override
  Duration get transitionDuration => _kModalDateRangePickerDuration;
}

// Positioning of the date picker dropdown on the screen
class _DateRangePickerDropdownRouteLayout extends SingleChildLayoutDelegate {
  _DateRangePickerDropdownRouteLayout(this.position);

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
  bool shouldRelayout(_DateRangePickerDropdownRouteLayout oldDelegate) {
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
        initialStartDate: route.initialDateRange == null
            ? null
            : route.initialDateRange.start,
        initialEndDate:
            route.initialDateRange == null ? null : route.initialDateRange.end,
        firstDate: route.firstDate,
        lastDate: route.lastDate,
        onDateRangeChanged: (newValue) {
          //Navigator.of(context).pop(newValue);
        },
      ),
    );
  }
}
