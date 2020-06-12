import 'package:flutter/services.dart';

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
