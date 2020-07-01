import 'package:flutter/widgets.dart';

mixin ChatItemMixin on Widget {
  routeToChat(BuildContext context, String identity) {
    Navigator.pushNamed(context, '/chat', arguments: identity);
  }
}
