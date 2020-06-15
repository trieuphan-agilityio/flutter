// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show hashValues;

import 'package:flutter/foundation.dart';

/// Encapsulates a start and end [DateTime] that represent the range of dates
/// between them.
///
/// See also:
///  * [showDateRangePicker], which displays a dialog that allows the user to
///    select a date range.
@immutable
class DateTimeRange {
  /// Creates a date range for the given start and end [DateTime].
  ///
  /// [start] and [end] must be non-null.
  const DateTimeRange({
    @required this.start,
    @required this.end,
  })  : assert(start != null),
        assert(end != null);

  /// The start of the range of dates.
  final DateTime start;

  /// The end of the range of dates.
  final DateTime end;

  /// Returns a [Duration] of the time between [start] and [end].
  ///
  /// See [DateTime.difference] for more details.
  Duration get duration => end.difference(start);

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is DateTimeRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => hashValues(start, end);
}
