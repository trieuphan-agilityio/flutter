import 'package:flutter/widgets.dart';
import 'package:phone_auth/screens/cart/cart_screen.dart';
import 'package:phone_auth/screens/complete_profile/complete_profile_screen.dart';
import 'package:phone_auth/screens/details/details_screen.dart';
import 'package:phone_auth/screens/forgot_password/forgot_password_screen.dart';
import 'package:phone_auth/screens/home/home_screen.dart';
import 'package:phone_auth/screens/login_success/login_success_screen.dart';
import 'package:phone_auth/screens/sign_in/sign_in_screen.dart';
import 'package:phone_auth/screens/splash/splash_screen.dart';

import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
};
