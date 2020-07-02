import 'package:flutter/widgets.dart';

mixin ChatRouteMixin on Widget {
  routeToChat(BuildContext context, String identity) {
    Navigator.pushNamed(context, '/chat', arguments: identity);
  }
}
