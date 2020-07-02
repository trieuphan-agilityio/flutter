import 'package:flutter/widgets.dart';

class WidgetUtils {
  /// join function for the list of Widgets
  static List<Widget> join(List<Widget> widgets, Widget separator) {
    Iterator<Widget> iterator = widgets.iterator;
    if (!iterator.moveNext()) return [];

    if (separator == null) return widgets;

    List<Widget> newList = [];
    newList.add(iterator.current);

    while (iterator.moveNext()) {
      newList.add(separator);
      newList.add(iterator.current);
    }

    return newList;
  }
}
