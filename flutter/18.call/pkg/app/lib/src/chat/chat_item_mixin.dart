import 'package:app/core.dart';

import 'chat.dart';

mixin ChatRouteMixin on Widget {
  routeToChat(BuildContext context, String identity) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return Chat(identity: identity);
        },
      ),
    );
  }
}
