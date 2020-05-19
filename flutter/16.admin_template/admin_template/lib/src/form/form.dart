import 'package:flutter/widgets.dart';

typedef WidgetBuilder = Widget Function(BuildContext);

abstract class AgForm<T> {
  T get model;
  WidgetBuilder get builder;
}
