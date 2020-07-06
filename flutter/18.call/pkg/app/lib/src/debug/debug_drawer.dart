import 'package:app/core.dart';
import 'package:app/src/debug/access_token_settings.dart';

const _kDivider = const Divider(height: 0.5, thickness: 0.5);

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
            _kDivider,
            ListTile(
              title: Text('Simulate a call after 5s'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _kDivider,
          ]),
        ),
      ),
    );
  }
}
