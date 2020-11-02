import 'package:flutter/material.dart';
import 'package:phone_auth/size_config.dart';

import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";

  final String phoneNumber;

  const OtpScreen({Key key, @required this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
      ),
      body: Body(phoneNumber: phoneNumber),
    );
  }
}
