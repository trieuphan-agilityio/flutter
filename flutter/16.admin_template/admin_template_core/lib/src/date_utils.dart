import 'date_time_range.dart';

/// Returns a [DateTime] with just the date of the original, but no time set.
DateTime dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

/// Returns a [DateTimeRange] with the dates of the original without any times set.
DateTimeRange datesOnly(DateTimeRange range) {
  return DateTimeRange(start: dateOnly(range.start), end: dateOnly(range.end));
}

/// Returns true if the two [DateTime] objects have the same day, month, and
/// year.
bool isSameDay(DateTime dateA, DateTime dateB) {
  return dateA.year == dateB.year &&
      dateA.month == dateB.month &&
      dateA.day == dateB.day;
}

/// Determines the number of months between two [DateTime] objects.
///
/// For example:
/// ```
/// DateTime date1 = DateTime(year: 2019, month: 6, day: 15);
/// DateTime date2 = DateTime(year: 2020, month: 1, day: 15);
/// int delta = monthDelta(date1, date2);
/// ```
///
/// The value for `delta` would be `7`.
int monthDelta(DateTime startDate, DateTime endDate) {
  return (endDate.year - startDate.year) * 12 + endDate.month - startDate.month;
}
