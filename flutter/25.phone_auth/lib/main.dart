import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/routes.dart';
import 'package:phone_auth/screens/otp/otp_screen.dart';
import 'package:phone_auth/screens/splash/splash_screen.dart';
import 'package:phone_auth/theme.dart';
import 'package:provider/provider.dart';

import 'models/Auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => AuthModel()),

        // ROOT CONTEXT, Allows Commands to retrieve a 'safe' context that is not
        // tied to any one view. Allows them to work on async tasks without issues.
        Provider<BuildContext>(create: (c) => c),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme(),
      // home: SplashScreen(),
      // We use routeName so that we dont need to remember the name
      initialRoute: SplashScreen.routeName,
      routes: routes,
      onGenerateRoute: (settings) {
        // If you push the PassArguments route
        if (settings.name == OtpScreen.routeName) {
          return MaterialPageRoute(
            builder: (context) {
              return OtpScreen(phoneNumber: settings.arguments);
            },
          );
        }
        return null;
      },
    );
  }
}
