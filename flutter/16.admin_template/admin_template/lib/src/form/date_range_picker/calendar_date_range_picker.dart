// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:admin_template/src/utils/line_painter.dart';
import 'package:admin_template_core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide DateTimeRange;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../date_utils.dart' as utils;

const int _maxDayPickerRowCount = 6; // A 31 day month that starts on Saturday.
const double _dayPickerRowHeight = 28.0;
const double _horizontalPadding = 8.0;
const double _maxCalendarHeight = 280.0;
const double _maxCalendarWidth = 256.0;
const double _monthItemFooterHeight = 8.0;
const double _monthItemHeaderHeight = 58.0;
const double _monthItemRowHeight = 28.0;
const double _monthItemSpaceBetweenRows = 4.0;
const double _monthPickerHorizontalPadding = 8.0;
const Widget _kMonthDivider = VerticalDivider(width: 1.0, thickness: 1.0);

/// Displays a grid of days for a given month and allows the user to select a date.
///
/// Days are arranged in a rectangular grid with one column for each day of the
/// week. Controls are provided to change the year and month that the grid is
/// showing.
///
/// The calendar picker widget is rarely used directly. Instead, consider using
/// [showDateRangePicker], which will create a dialog that uses this as well as provides
/// a text entry option.
///
/// See also:
///
///  * [showDateRangePicker], which creates a Dialog that contains a [CalendarDateRangePicker]
///    and provides an optional compact view where the user can enter a date as
///    a line of text.
///  * [showTimePicker], which shows a dialog that contains a material design
///    time picker.
///
class CalendarDateRangePicker extends StatefulWidget {
  /// Creates a calender date picker
  ///
  /// It will display a grid of days for the [initialDate]'s month. The day
  /// indicated by [initialDate] will be selected.
  ///
  /// The optional [onDisplayedMonthChanged] callback can be used to track
  /// the currently displayed month.
  ///
  /// The [initialDate], [firstDate], [lastDate], [onDateChanged] must be non-null.
  ///
  /// [lastDate] must be after or equal to [firstDate].
  ///
  /// [initialDate] must be between [firstDate] and [lastDate] or equal to
  /// one of them.
  ///
  /// [currentDate] represents the current day (i.e. today). This
  /// date will be highlighted in the day grid. If null, the date of
  /// `DateTime.now()` will be used.
  ///
  /// If [selectableDayPredicate] is non-null, it must return `true` for the
  /// [initialDate].
  CalendarDateRangePicker({
    Key key,
    DateTime initialStartDate,
    DateTime initialEndDate,
    @required DateTime firstDate,
    @required DateTime lastDate,
    DateTime currentDate,
    @required this.onDateRangeChanged,
  })  : initialStartDate =
            initialStartDate != null ? dateOnly(initialStartDate) : null,
        initialEndDate =
            initialEndDate != null ? dateOnly(initialEndDate) : null,
        assert(firstDate != null),
        assert(lastDate != null),
        firstDate = dateOnly(firstDate),
        lastDate = dateOnly(lastDate),
        currentDate = dateOnly(currentDate ?? DateTime.now()),
        super(key: key) {
    assert(
        this.initialStartDate == null ||
            this.initialEndDate == null ||
            !this.initialStartDate.isAfter(initialEndDate),
        'initialStartDate must be on or before initialEndDate.');
    assert(!this.lastDate.isBefore(this.firstDate),
        'firstDate must be on or before lastDate.');
  }

  /// The [DateTime] that represents the start of the initial date range selection.
  final DateTime initialStartDate;

  /// The [DateTime] that represents the end of the initial date range selection.
  final DateTime initialEndDate;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  /// Called when the user changes the date range.
  final ValueChanged<DateTimeRange> onDateRangeChanged;

  @override
  _CalendarDateRangePickerState createState() =>
      _CalendarDateRangePickerState();
}

class _CalendarDateRangePickerState extends State<CalendarDateRangePicker> {
  DateTime _startDate;
  DateTime _endDate;
  DateTime _dateOnHover;

  int _initialMonthIndex = 0;
  ScrollController _controller;
  bool _showWeekBottomDivider;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;

    // Calculate the index for the initially displayed month. This is needed to
    // divide the list of months into two `SliverList`s.
    final DateTime initialDate = widget.initialStartDate ?? widget.currentDate;
    if (widget.firstDate.isBefore(initialDate) &&
        widget.lastDate.isAfter(initialDate)) {
      _initialMonthIndex = monthDelta(widget.firstDate, initialDate);
    }

    _showWeekBottomDivider = _initialMonthIndex != 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_controller.offset <= _controller.position.minScrollExtent) {
      setState(() {
        _showWeekBottomDivider = false;
      });
    } else if (!_showWeekBottomDivider) {
      setState(() {
        _showWeekBottomDivider = true;
      });
    }
  }

  /// Number of months that are selectable, the period time is from [firstDate]
  /// to [lastDate].
  int get _numberOfMonths => monthDelta(widget.firstDate, widget.lastDate) + 1;

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        HapticFeedback.vibrate();
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
  }

  /// Handle selection when user hovers on the calendar.
  void _updateOnHover(DateTime date) {
    setState(() {
      if (_startDate != null && _endDate == null) {
        if (date == null) {
          _dateOnHover = null;
        } else if (!date.isBefore(_startDate)) {
          _dateOnHover = date;
        }
      }
    });
  }

  // This updates the selected date range using this logic:
  //
  // * From the unselected state, selecting one date creates the start date.
  //   * If the next selection is before the start date, reset date range and
  //     set the start date to that selection.
  //   * If the next selection is on or after the start date, set the end date
  //     to that selection.
  // * After both start and end dates are selected, any subsequent selection
  //   resets the date range and sets start date to that selection.
  void _updateSelection(DateTime date) {
    _vibrate();
    setState(() {
      _dateOnHover = null;
      if (_startDate != null &&
          _endDate == null &&
          !date.isBefore(_startDate)) {
        _endDate = date;
      } else {
        _startDate = date;
        if (_endDate != null) {
          _endDate = null;
        }
      }
      if (_startDate != null && _endDate != null)
        widget.onDateRangeChanged(DateTimeRange(
          start: _startDate,
          end: _endDate,
        ));
    });
  }

  Widget _buildMonthItem(
      BuildContext context, int index, bool beforeInitialMonth) {
    // skip because this month was built in the previous iteration.
    if (index % 2 == 1) return SizedBox.shrink();

    final int monthIndex = beforeInitialMonth
        ? _initialMonthIndex - index - 1
        : _initialMonthIndex + index;

    final DateTime month =
        utils.addMonthsToMonthDate(widget.firstDate, monthIndex);
    final DateTime nextMonth = month.add(Duration(days: 45));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: _MonthItem(
            selectedDateStart: _startDate,
            selectedDateEnd: _endDate,
            dateOnHover: _dateOnHover,
            currentDate: widget.currentDate,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            displayedMonth: month,
            onChanged: _updateSelection,
            onHover: _updateOnHover,
          ),
        ),
        _kMonthDivider,
        Flexible(
          child: _MonthItem(
            selectedDateStart: _startDate,
            selectedDateEnd: _endDate,
            dateOnHover: _dateOnHover,
            currentDate: widget.currentDate,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            displayedMonth: nextMonth,
            onChanged: _updateSelection,
            onHover: _updateOnHover,
          ),
        ),
        _kMonthDivider,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const Key sliverAfterKey = Key('sliverAfterKey');

    return Stack(
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                controller: _controller,
                center: sliverAfterKey,
                physics: const NeverScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return _buildMonthItem(context, index, true);
                      },
                      childCount: _initialMonthIndex,
                    ),
                  ),
                  SliverList(
                    key: sliverAfterKey,
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) =>
                          _buildMonthItem(context, index, false),
                      childCount: _numberOfMonths - _initialMonthIndex,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Displays the days of a given month and allows choosing a date range.
///
/// The days are arranged in a rectangular grid with one column for each day of
/// the week.
class _MonthItem extends StatelessWidget {
  /// Creates a month item.
  _MonthItem({
    Key key,
    @required this.selectedDateStart,
    @required this.selectedDateEnd,
    @required this.dateOnHover,
    @required this.currentDate,
    @required this.onChanged,
    @required this.onHover,
    @required this.firstDate,
    @required this.lastDate,
    @required this.displayedMonth,
    this.dragStartBehavior = DragStartBehavior.start,
  })  : assert(firstDate != null),
        assert(lastDate != null),
        assert(!firstDate.isAfter(lastDate)),
        assert(selectedDateStart == null ||
            !selectedDateStart.isBefore(firstDate)),
        assert(selectedDateEnd == null || !selectedDateEnd.isBefore(firstDate)),
        assert(
            selectedDateStart == null || !selectedDateStart.isAfter(lastDate)),
        assert(selectedDateEnd == null || !selectedDateEnd.isAfter(lastDate)),
        assert(selectedDateStart == null ||
            selectedDateEnd == null ||
            !selectedDateStart.isAfter(selectedDateEnd)),
        assert(dateOnHover == null || !dateOnHover.isBefore(firstDate)),
        assert(dateOnHover == null || !dateOnHover.isAfter(lastDate)),
        assert(dateOnHover == null || selectedDateEnd == null),
        assert(dateOnHover == null || !dateOnHover.isBefore(selectedDateStart)),
        assert(currentDate != null),
        assert(onChanged != null),
        assert(onHover != null),
        assert(displayedMonth != null),
        assert(dragStartBehavior != null),
        super(key: key);

  /// The currently selected start date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDateStart;

  /// The currently selected end date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDateEnd;

  /// The currently hovered date.
  ///
  /// This date is highlighted in the picker.
  final DateTime dateOnHover;

  /// The current date at the time the picker is displayed.
  final DateTime currentDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// Called when the user hovers on a day.
  final ValueChanged<DateTime> onHover;

  /// The earliest date the user is permitted to pick.
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  final DateTime lastDate;

  /// The month whose days are displayed by this picker.
  final DateTime displayedMonth;

  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], the drag gesture used to scroll a
  /// date picker wheel will begin upon the detection of a drag gesture. If set
  /// to [DragStartBehavior.down] it will begin when a down event is first
  /// detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  ///
  /// See also:
  ///
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for
  ///    the different behaviors.
  final DragStartBehavior dragStartBehavior;

  Color _highlightColor(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Color.alphaBlend(
        colors.primary.withOpacity(0.12), colors.background);
  }

  Widget _buildDayItem(BuildContext context, DateTime dayToBuild,
      int firstDayOffset, int daysInMonth) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final TextDirection textDirection = Directionality.of(context);
    final Color highlightColor = _highlightColor(context);
    final int day = dayToBuild.day;

    final bool isDisabled =
        dayToBuild.isAfter(lastDate) || dayToBuild.isBefore(firstDate);

    BoxDecoration decoration;
    TextStyle itemStyle = textTheme.bodyText2;

    final bool isRangeSelected =
        selectedDateStart != null && selectedDateEnd != null;
    final bool isSelectedDayStart = selectedDateStart != null &&
        dayToBuild.isAtSameMomentAs(selectedDateStart);
    final bool isSelectedDayEnd =
        selectedDateEnd != null && dayToBuild.isAtSameMomentAs(selectedDateEnd);
    final bool isInRange = isRangeSelected &&
        dayToBuild.isAfter(selectedDateStart) &&
        dayToBuild.isBefore(selectedDateEnd);
    _HighlightPainter highlightPainter;

    if (isSelectedDayStart || isSelectedDayEnd) {
      // The selected start and end dates gets a circle background
      // highlight, and a contrasting text color.
      itemStyle = textTheme.bodyText2?.apply(color: colorScheme.onPrimary);
      decoration = BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
      );

      if (isRangeSelected && selectedDateStart != selectedDateEnd) {
        final _HighlightPainterStyle style = isSelectedDayStart
            ? _HighlightPainterStyle.highlightTrailing
            : _HighlightPainterStyle.highlightLeading;
        highlightPainter = _HighlightPainter(
          color: highlightColor,
          style: style,
          textDirection: textDirection,
        );
      }
    } else if (isInRange) {
      // The days within the range get a light background highlight.
      highlightPainter = _HighlightPainter(
        color: highlightColor,
        style: _HighlightPainterStyle.highlightAll,
        textDirection: textDirection,
      );
    } else if (isDisabled) {
      itemStyle = textTheme.bodyText2
          ?.apply(color: colorScheme.onSurface.withOpacity(0.38));
    } else if (isSameDay(currentDate, dayToBuild)) {
      // The current day gets a different text color and a circle stroke
      // border.
      itemStyle = textTheme.bodyText2?.apply(color: colorScheme.primary);
      decoration = BoxDecoration(
        border: Border.all(color: colorScheme.primary, width: 1),
        shape: BoxShape.circle,
      );
    }

    // We want the day of month to be spoken first irrespective of the
    // locale-specific preferences or TextDirection. This is because
    // an accessibility user is more likely to be interested in the
    // day of month before the rest of the date, as they are looking
    // for the day of month. To do that we prepend day of month to the
    // formatted full date.
    final String fullDate = localizations.formatFullDate(dayToBuild);
    String semanticLabel = fullDate;
    if (isSelectedDayStart) {
      semanticLabel = localizations.dateRangeStartDateSemanticLabel(fullDate);
    } else if (isSelectedDayEnd) {
      semanticLabel = localizations.dateRangeEndDateSemanticLabel(fullDate);
    }

    Widget dayWidget = Container(
      decoration: decoration,
      child: Center(
        child: Semantics(
          label: semanticLabel,
          selected: isSelectedDayStart || isSelectedDayEnd,
          child: ExcludeSemantics(
            child: Text(localizations.formatDecimal(day), style: itemStyle),
          ),
        ),
      ),
    );

    if (highlightPainter != null) {
      dayWidget = CustomPaint(
        painter: highlightPainter,
        child: dayWidget,
      );
    }

    if (!isDisabled) {
      dayWidget = MouseRegion(
        onEnter: (e) => onHover(dayToBuild),
        child: dayWidget,
      );
    }

    if (!isDisabled) {
      dayWidget = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          onChanged(dayToBuild);
        },
        child: dayWidget,
        dragStartBehavior: dragStartBehavior,
      );
    }

    return dayWidget;
  }

  Widget _buildEdgeContainer(BuildContext context, bool isHighlighted) {
    return Container(color: isHighlighted ? _highlightColor(context) : null);
  }

  List<Widget> _buildHoverDecoration(BuildContext context,
      List<Widget> dayItems, int numOfWeeks, int dayOffset) {
    assert(selectedDateStart != null);
    assert(dateOnHover != null);

    final int year = displayedMonth.year;
    final int month = displayedMonth.month;

    // Decorate day items on hover range
    final List<Widget> decoratedDayItems = <Widget>[];
    for (int i = 0; i < numOfWeeks; i++) {
      final int start = i * DateTime.daysPerWeek;
      final int end = math.min(
        start + DateTime.daysPerWeek,
        dayItems.length,
      );

      List<Widget> weekList = dayItems.sublist(start, end);
      final TextDirection textDirection = Directionality.of(context);
      final Color highlightColor = _highlightColor(context);

      final List<Widget> decoratedWeekList = <Widget>[];
      bool isLeading;
      bool isTrailing;
      for (int j = 0; j < weekList.length; j++) {
        final Widget dayWidget = weekList[j];
        _HighlightPainterStyle painterStyle;

        final int day = start - dayOffset + 1 + j;

        if (day < 0) {
          decoratedWeekList.add(dayWidget);
          continue;
        }

        final DateTime dayToBuild = DateTime(year, month, day);

        final bool isDisabled =
            dayToBuild.isAfter(lastDate) || dayToBuild.isBefore(firstDate);

        if (isDisabled) {
          decoratedWeekList.add(dayWidget);
          continue;
        }

        // first meaning day is the leading
        isLeading = isLeading == null ? true : false;

        // last meaning day is the trailing
        isTrailing = j == weekList.length - 1 ? true : false;

        final bool isInHoverRange = dayToBuild.isAfter(selectedDateStart) &&
            !dayToBuild.isAfter(dateOnHover);

        final bool isSelectedStartDay =
            dayToBuild.isAtSameMomentAs(selectedDateStart);

        final bool isDayOnHover = dayToBuild.isAtSameMomentAs(dateOnHover);

        if (isSelectedStartDay && !isDayOnHover) {
          painterStyle = _HighlightPainterStyle.highlightLeadingOnHover;
        } else if (isDayOnHover && !isSelectedStartDay) {
          painterStyle = _HighlightPainterStyle.highlightTrailingOnHover;
        } else if (isLeading && isInHoverRange) {
          painterStyle = _HighlightPainterStyle.highlightLeadingOnHover;
        } else if (isTrailing && isInHoverRange) {
          painterStyle = _HighlightPainterStyle.highlightTrailingOnHover;
        } else if (isInHoverRange && !isSelectedStartDay) {
          painterStyle = _HighlightPainterStyle.highlightAllOnHover;
        }

        if (painterStyle == null) {
          decoratedWeekList.add(dayWidget);
          continue;
        }

        decoratedWeekList.add(CustomPaint(
          painter: _HighlightPainter(
            textDirection: textDirection,
            color: highlightColor,
            style: painterStyle,
          ),
          child: dayWidget,
        ));
      }

      decoratedDayItems.addAll(decoratedWeekList);
    }

    return decoratedDayItems;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final int year = displayedMonth.year;
    final int month = displayedMonth.month;
    final int daysInMonth = utils.getDaysInMonth(year, month);
    final int dayOffset = utils.firstDayOffset(year, month, localizations);
    final int weeks = ((daysInMonth + dayOffset) / DateTime.daysPerWeek).ceil();
    final double gridHeight =
        weeks * _monthItemRowHeight + (weeks - 1) * _monthItemSpaceBetweenRows;
    final List<Widget> dayItems = <Widget>[];

    for (int i = 0; true; i += 1) {
      // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
      // a leap year.
      final int day = i - dayOffset + 1;
      if (day > daysInMonth) break;
      if (day < 1) {
        dayItems.add(Container());
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final Widget dayItem = _buildDayItem(
          context,
          dayToBuild,
          dayOffset,
          daysInMonth,
        );
        dayItems.add(dayItem);
      }
    }

    List<Widget> decoratedDayItems;
    if (selectedDateStart == null || dateOnHover == null)
      // skip the decorating if it isn't hovered
      decoratedDayItems = dayItems;
    else
      decoratedDayItems =
          _buildHoverDecoration(context, dayItems, weeks, dayOffset);

    // Add the leading/trailing edge containers to each week in order to
    // correctly extend the range highlight.
    final List<Widget> paddedDayItems = <Widget>[];
    for (int i = 0; i < weeks; i++) {
      final int start = i * DateTime.daysPerWeek;
      final int end = math.min(
        start + DateTime.daysPerWeek,
        decoratedDayItems.length,
      );
      final List<Widget> weekList = decoratedDayItems.sublist(start, end);

      final DateTime dateAfterLeadingPadding =
          DateTime(year, month, start - dayOffset + 1);
      // Only color the edge container if it is after the start date and
      // on/before the end date.
      final bool isLeadingInRange = !(dayOffset > 0 && i == 0) &&
          selectedDateStart != null &&
          selectedDateEnd != null &&
          dateAfterLeadingPadding.isAfter(selectedDateStart) &&
          !dateAfterLeadingPadding.isAfter(selectedDateEnd);
      weekList.insert(0, _buildEdgeContainer(context, isLeadingInRange));

      // Only add a trailing edge container if it is for a full week and not a
      // partial week.
      if (end < decoratedDayItems.length ||
          (end == decoratedDayItems.length &&
              decoratedDayItems.length % DateTime.daysPerWeek == 0)) {
        final DateTime dateBeforeTrailingPadding =
            DateTime(year, month, end - dayOffset);
        // Only color the edge container if it is on/after the start date and
        // before the end date.
        final bool isTrailingInRange = selectedDateStart != null &&
            selectedDateEnd != null &&
            !dateBeforeTrailingPadding.isBefore(selectedDateStart) &&
            dateBeforeTrailingPadding.isBefore(selectedDateEnd);
        weekList.add(_buildEdgeContainer(context, isTrailingInRange));
      }

      paddedDayItems.addAll(weekList);
    }

    return Column(
      children: <Widget>[
        Container(
          constraints: BoxConstraints(maxWidth: _maxCalendarWidth),
          height: _monthItemHeaderHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: AlignmentDirectional.center,
          child: ExcludeSemantics(
            child: Text(
              localizations.formatMonthYear(displayedMonth),
              style: textTheme.bodyText2
                  .apply(color: themeData.colorScheme.onSurface),
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints.tightFor(
            width: _maxCalendarWidth,
            height: _dayPickerRowHeight,
          ),
          child: _DayHeaders(),
        ),
        Expanded(
          child: Container(
            constraints: BoxConstraints.tightFor(
              width: _maxCalendarWidth,
              height: gridHeight,
            ),
            child: GridView.custom(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: _monthItemGridDelegate,
              childrenDelegate: SliverChildListDelegate(
                paddedDayItems,
                addRepaintBoundaries: false,
              ),
            ),
          ),
        ),
        //const SizedBox(height: _monthItemFooterHeight),
      ],
    );
  }
}

class _DayPickerGridDelegate extends SliverGridDelegate {
  const _DayPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const int columnCount = DateTime.daysPerWeek;
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    final double tileHeight = _dayPickerRowHeight;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: tileHeight,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: tileHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_DayPickerGridDelegate oldDelegate) => false;
}

const _DayPickerGridDelegate _dayPickerGridDelegate = _DayPickerGridDelegate();

class _DayHeaders extends StatelessWidget {
  /// Builds widgets showing abbreviated days of week. The first widget in the
  /// returned list corresponds to the first day of week for the current locale.
  ///
  /// Examples:
  ///
  /// ```
  /// ┌ Sunday is the first day of week in the US (en_US)
  /// |
  /// S M T W T F S  <-- the returned list contains these widgets
  /// _ _ _ _ _ 1 2
  /// 3 4 5 6 7 8 9
  ///
  /// ┌ But it's Monday in the UK (en_GB)
  /// |
  /// M T W T F S S  <-- the returned list contains these widgets
  /// _ _ _ _ 1 2 3
  /// 4 5 6 7 8 9 10
  /// ```
  List<Widget> _getDayHeaders(
      TextStyle headerStyle, MaterialLocalizations localizations) {
    final List<Widget> result = <Widget>[];
    for (int i = localizations.firstDayOfWeekIndex; true; i = (i + 1) % 7) {
      final String weekday = localizations.narrowWeekdays[i];
      result.add(ExcludeSemantics(
        child: Center(child: Text(weekday, style: headerStyle)),
      ));
      if (i == (localizations.firstDayOfWeekIndex - 1) % 7) break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextStyle dayHeaderStyle = theme.textTheme.caption?.apply(
      color: colorScheme.onSurface.withOpacity(0.60),
    );
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final List<Widget> labels = _getDayHeaders(dayHeaderStyle, localizations);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _monthPickerHorizontalPadding,
      ),
      child: GridView.custom(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: _dayPickerGridDelegate,
        childrenDelegate: SliverChildListDelegate(
          labels,
          addRepaintBoundaries: false,
        ),
      ),
    );
  }
}

class _MonthItemGridDelegate extends SliverGridDelegate {
  const _MonthItemGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth =
        (constraints.crossAxisExtent - 2 * _horizontalPadding) /
            DateTime.daysPerWeek;
    return _MonthSliverGridLayout(
      crossAxisCount: DateTime.daysPerWeek + 2,
      dayChildWidth: tileWidth,
      edgeChildWidth: _horizontalPadding,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_MonthItemGridDelegate oldDelegate) => false;
}

const _MonthItemGridDelegate _monthItemGridDelegate = _MonthItemGridDelegate();

class _MonthSliverGridLayout extends SliverGridLayout {
  /// Creates a layout that uses equally sized and spaced tiles for each day of
  /// the week and an additional edge tile for padding at the start and end of
  /// each row.
  ///
  /// This is necessary to facilitate the painting of the range highlight
  /// correctly.
  const _MonthSliverGridLayout({
    @required this.crossAxisCount,
    @required this.dayChildWidth,
    @required this.edgeChildWidth,
    @required this.reverseCrossAxis,
  })  : assert(crossAxisCount != null && crossAxisCount > 0),
        assert(dayChildWidth != null && dayChildWidth >= 0),
        assert(edgeChildWidth != null && edgeChildWidth >= 0),
        assert(reverseCrossAxis != null);

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The width in logical pixels of the day child widgets.
  final double dayChildWidth;

  /// The width in logical pixels of the edge child widgets.
  final double edgeChildWidth;

  /// Whether the children should be placed in the opposite order of increasing
  /// coordinates in the cross axis.
  ///
  /// For example, if the cross axis is horizontal, the children are placed from
  /// left to right when [reverseCrossAxis] is false and from right to left when
  /// [reverseCrossAxis] is true.
  ///
  /// Typically set to the return value of [axisDirectionIsReversed] applied to
  /// the [SliverConstraints.crossAxisDirection].
  final bool reverseCrossAxis;

  /// The number of logical pixels from the leading edge of one row to the
  /// leading edge of the next row.
  double get _rowHeight {
    return _monthItemRowHeight + _monthItemSpaceBetweenRows;
  }

  /// The height in logical pixels of the children widgets.
  double get _childHeight {
    return _monthItemRowHeight;
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    return crossAxisCount * (scrollOffset ~/ _rowHeight);
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    final int mainAxisCount = (scrollOffset / _rowHeight).ceil();
    return math.max(0, crossAxisCount * mainAxisCount - 1);
  }

  double _getCrossAxisOffset(double crossAxisStart, bool isPadding) {
    if (reverseCrossAxis) {
      return ((crossAxisCount - 2) * dayChildWidth + 2 * edgeChildWidth) -
          crossAxisStart -
          (isPadding ? edgeChildWidth : dayChildWidth);
    }
    return crossAxisStart;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final int adjustedIndex = index % crossAxisCount;
    final bool isEdge =
        adjustedIndex == 0 || adjustedIndex == crossAxisCount - 1;
    final double crossAxisStart =
        math.max(0, (adjustedIndex - 1) * dayChildWidth + edgeChildWidth);

    return SliverGridGeometry(
      scrollOffset: (index ~/ crossAxisCount) * _rowHeight,
      crossAxisOffset: _getCrossAxisOffset(crossAxisStart, isEdge),
      mainAxisExtent: _childHeight,
      crossAxisExtent: isEdge ? edgeChildWidth : dayChildWidth,
    );
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    assert(childCount >= 0);
    final int mainAxisCount = ((childCount - 1) ~/ crossAxisCount) + 1;
    final double mainAxisSpacing = _rowHeight - _childHeight;
    return _rowHeight * mainAxisCount - mainAxisSpacing;
  }
}

/// Determines which style to use to paint the highlight.
enum _HighlightPainterStyle {
  /// Paints nothing.
  none,

  /// Paints a rectangle that occupies the leading half of the space.
  highlightLeading,

  /// Paints a rectangle that occupies the trailing half of the space.
  highlightTrailing,

  /// Paints a rectangle that occupies all available space.
  highlightAll,

  /// Paints an outline rectangle that occupies the leading half of the space.
  highlightLeadingOnHover,

  /// Paints an outline rectangle that occupies the trailing half of the space.
  highlightTrailingOnHover,

  /// Paint an outline rectangle that occupies all available space.
  highlightAllOnHover,
}

/// This custom painter will add a background highlight to its child.
///
/// This highlight will be drawn depending on the [style], [color], and
/// [textDirection] supplied. It will either paint a rectangle on the
/// left/right, a full rectangle, or nothing at all. This logic is determined by
/// a combination of the [style] and [textDirection].
class _HighlightPainter extends CustomPainter {
  _HighlightPainter({
    this.color,
    this.style = _HighlightPainterStyle.none,
    this.textDirection,
  });

  final Color color;
  final _HighlightPainterStyle style;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    if (style == _HighlightPainterStyle.none) {
      return;
    }

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Paint paintOnHover = Paint()
      ..color = color
      ..style = PaintingStyle.stroke;

    // This ensures no gaps in the highlight track due to floating point
    // division of the available screen width.
    final double width = size.width + 1;
    final Rect rectLeft = Rect.fromLTWH(0, 0, width / 2, size.height);
    final Rect rectRight =
        Rect.fromLTWH(size.width / 2, 0, width / 2, size.height);

    final double squareLength = math.min(size.width, size.height);
    final Rect squareOfCirle = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: squareLength,
      height: squareLength,
    );

    switch (style) {
      case _HighlightPainterStyle.highlightTrailing:
        canvas.drawRect(
          textDirection == TextDirection.ltr ? rectRight : rectLeft,
          paint,
        );
        break;
      case _HighlightPainterStyle.highlightLeading:
        canvas.drawRect(
          textDirection == TextDirection.ltr ? rectLeft : rectRight,
          paint,
        );
        break;
      case _HighlightPainterStyle.highlightAll:
        canvas.drawRect(
          Rect.fromLTWH(0, 0, width, size.height),
          paint,
        );
        break;
      case _HighlightPainterStyle.highlightTrailingOnHover:
        // draw an half-right arc
        _drawDashArc(
          canvas,
          squareOfCirle,
          -0.5 * math.pi,
          math.pi,
          paintOnHover,
          color,
        );
        _drawDashLine(
          canvas,
          Offset.zero,
          Offset(size.width / 2, 0),
          paintOnHover,
          color,
        );
        _drawDashLine(
          canvas,
          Offset(0, size.height),
          Offset(size.width / 2, size.height),
          paintOnHover,
          color,
        );
        break;
      case _HighlightPainterStyle.highlightLeadingOnHover:
        // draw an half-left arc
        _drawDashArc(
          canvas,
          squareOfCirle,
          0.5 * math.pi,
          math.pi,
          paintOnHover,
          color,
        );
        _drawDashLine(
          canvas,
          Offset(size.width / 2, 0),
          Offset(size.width, 0),
          paintOnHover,
          color,
        );
        _drawDashLine(
          canvas,
          Offset(size.width / 2, size.height),
          Offset(size.width, size.height),
          paintOnHover,
          color,
        );
        break;
      case _HighlightPainterStyle.highlightAllOnHover:
        _drawDashLine(
          canvas,
          Offset.zero,
          Offset(size.width, 0),
          paintOnHover,
          color,
        );
        _drawDashLine(
          canvas,
          Offset(0, size.height),
          Offset(size.width, size.height),
          paintOnHover,
          color,
        );
        break;
      default:
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// ===================================================================
/// Utility to draw dash line/arc
/// ===================================================================

LinePainter _linePainter;

/// Draw a dash line of 2 given points.
void _drawDashLine(
  Canvas canvas,
  Offset p1,
  Offset p2,
  Paint paint,
  Color strokeColor,
) {
  _linePainter ??= new LinePainter();
  _linePainter.draw(
      canvas: canvas,
      paint: paint,
      points: [math.Point(p1.dx, p1.dy), math.Point(p2.dx, p2.dy)],
      stroke: strokeColor,
      dashPattern: <int>[3]);
}

/// Draw a simple dash arc.
void _drawDashArc(
  Canvas canvas,
  Rect rect,
  double startAngle,
  double sweepAngle,
  Paint paint,
  Color strokeColor,
) {
  final int dashLength = 3;
  final double radius = rect.width / 2;
  // based on the arc length formula S = r0, we can find r as follow.
  final stepAngle = dashLength / radius;

  double drawedAngle = 0;
  while (drawedAngle < sweepAngle) {
    // draw arc with angle is computed as above.
    canvas.drawArc(rect, startAngle + drawedAngle, stepAngle, false, paint);

    // jump to next step;
    drawedAngle += stepAngle * 2;
  }
}
