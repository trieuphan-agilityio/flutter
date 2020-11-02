import 'package:flutter/material.dart';
import 'package:phone_auth/commands/verify_phone_command.dart';
import 'package:phone_auth/constants.dart';
import 'package:phone_auth/screens/home/home_screen.dart';
import 'package:phone_auth/size_config.dart';

import 'otp_form.dart';

class Body extends StatefulWidget {
  final String phoneNumber;

  const Body({Key key, @required this.phoneNumber}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    _verifyPhoneNumber();
    super.initState();
  }

  _verifyPhoneNumber() {
    VerifyPhoneCommand(context).execute(widget.phoneNumber).then((ok) {
      if (ok) {
        Navigator.pushNamed(context, HomeScreen.routeName);
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Failed to verify phone number!"),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              Text(
                "OTP Verification",
                style: headingStyle,
              ),
              Text("We sent your code to +1 898 860 ***"),
              buildTimer(),
              OtpForm(),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              GestureDetector(
                onTap: () {
                  // resend otp
                  _verifyPhoneNumber();
                },
                child: Text(
                  "Resend OTP Code",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 60.0, end: 0.0),
          duration: Duration(seconds: 60),
          builder: (_, value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
