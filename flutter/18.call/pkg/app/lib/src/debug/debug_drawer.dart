import 'package:app/core.dart';
import 'package:app/src/debug/access_token_settings.dart';

class DebugDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(children: [
            DrawerHeader(
              decoration: const FlutterLogoDecoration(),
              child: Container(),
            ),
            ListTile(
              title: Text('Set Twilio Access Token'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) {
                      return AccessTokenSettings();
                    },
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
