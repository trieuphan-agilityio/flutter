import 'package:app/core.dart';
import 'package:app/src/debug/access_token_settings.dart';
import 'package:app/src/debug/device_permissions.dart';

const _kDivider = const Divider(height: 0.5, thickness: 0.5);

class DebugDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(children: [
            Container(
              height: 180,
              decoration: const FlutterLogoDecoration(),
            ),
            _kDivider,
            ...WidgetUtils.join(buildOptions(context), _kDivider),
          ]),
        ),
      ),
    );
  }

  List<Widget> buildOptions(BuildContext context) {
    return [
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
      ListTile(
        title: Text('Simulate a call after 5s'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        title: Text('Check device permissions'),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) {
                return DevicePermissions();
              },
            ),
          );
        },
      ),
    ];
  }
}
