import 'package:flutter/widgets.dart';

/// Signature for creating a form widget
typedef FormBuilder<T> = Widget Function(
  BuildContext context, {
  bool autovalidate,
  WillPopCallback onWillPop,
  VoidCallback onChanged,
  ValueChanged<T> onSaved,
});
