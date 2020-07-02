import 'package:app/core.dart';
import 'package:app/splash.dart';
import 'package:app/src/app_services/app_services.dart';
import 'package:app/src/app_services/video_call_service.dart';
import 'package:app/src/chat/chat.dart';
import 'package:flutter/material.dart';

import 'src/auth/auth.dart';
import 'src/home/home.dart';

void main() {
  /// Some services such as SharedPreferences need access to binary messenger
  /// before app run. Therefore we need to initialise Flutter Binding from early.
  WidgetsFlutterBinding.ensureInitialized();

  final appServices = AppServices.create(
    VideoCallService(),
    AuthService(),
    SharedPreferencesService(),
  );

  runApp(App(appServices));
}

class App extends StatelessWidget {
  const App(this.appServices, {Key key}) : super(key: key);

  final Future<AppServices> appServices;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: appServices,
      builder: (context, snapshot) {
        return MultiProvider(
          providers: <Provider>[
            Provider<AppServices>.value(value: snapshot.data),
          ],
          child: MaterialApp(
            builder: (BuildContext context, Widget child) {
              return child;
            },
            home: snapshot.hasData ? Auth() : Splash(),
            routes: {
              '/home': (_) => Home(),
            },
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/chat':
                  final String identity = settings.arguments;
                  return MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) {
                      return Chat(identity: identity);
                    },
                  );

                default:
                  throw FlutterError('Not implemented yet');
              }
            },
          ),
        );
      },
    );
  }
}
