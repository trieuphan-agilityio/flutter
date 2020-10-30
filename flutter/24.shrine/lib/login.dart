// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shrine/command/sign_in_command.dart';

import 'package:shrine/data/gallery_options.dart';
import 'package:shrine/layout/adaptive.dart';
import 'package:shrine/layout/image_placeholder.dart';
import 'package:shrine/layout/letter_spacing.dart';
import 'package:shrine/layout/text_scale.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shrine/app.dart';
import 'package:shrine/colors.dart';
import 'package:shrine/theme.dart';

const _horizontalPadding = 24.0;

double desktopLoginScreenMainAreaWidth({BuildContext context}) {
  return min(
    360 * reducedTextScale(context),
    MediaQuery.of(context).size.width - 2 * _horizontalPadding,
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ApplyTextOptions(
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white),
        body: SafeArea(
          child: ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: _horizontalPadding,
            ),
            children: [
              SizedBox(height: 80),
              _ShrineLogo(),
              SizedBox(height: 120),
              _UsernameTextField(emailController: _emailController),
              SizedBox(height: 12),
              _PasswordTextField(passwordController: _passwordController),
              Builder(
                builder: (context) => _CancelAndNextButtons(
                  onNext: () async {
                    final ok = await SignInWithEmailCommand(context).execute(
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (ok) {
                      Navigator.of(context).pushNamed(ShrineApp.homeRoute);
                    }
                  },
                  onCancel: () {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Failed to sign in with Email & Password"),
                    ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShrineLogo extends StatelessWidget {
  const _ShrineLogo();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Column(
        children: [
          FadeInImagePlaceholder(
            image: const AssetImage('packages/shrine_images/diamond.png'),
            placeholder: Container(
              width: 34,
              height: 34,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'SHRINE',
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}

class _UsernameTextField extends StatelessWidget {
  const _UsernameTextField({@required this.emailController});

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PrimaryColorOverride(
      color: shrineBrown900,
      child: Container(
        child: TextField(
          controller: emailController,
          cursorColor: colorScheme.onSurface,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).shrineLoginUsernameLabel,
            labelStyle: TextStyle(
                letterSpacing: letterSpacingOrNone(mediumLetterSpacing)),
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({@required this.passwordController});

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PrimaryColorOverride(
      color: shrineBrown900,
      child: Container(
        child: TextField(
          controller: passwordController,
          cursorColor: colorScheme.onSurface,
          obscureText: true,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).shrineLoginPasswordLabel,
            labelStyle: TextStyle(
                letterSpacing: letterSpacingOrNone(mediumLetterSpacing)),
          ),
        ),
      ),
    );
  }
}

class _CancelAndNextButtons extends StatelessWidget {
  const _CancelAndNextButtons({@required this.onNext, @required this.onCancel});

  final VoidCallback onNext;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final isDesktop = isDisplayDesktop(context);

    final buttonTextPadding = isDesktop
        ? const EdgeInsets.symmetric(horizontal: 24, vertical: 16)
        : EdgeInsets.zero;

    return Wrap(
      children: [
        ButtonBar(
          buttonPadding: isDesktop ? EdgeInsets.zero : null,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
              ),
              child: Padding(
                padding: buttonTextPadding,
                child: Text(
                  AppLocalizations.of(context).shrineCancelButtonCaption,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ),
              onPressed: () => onCancel(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 8,
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
              ),
              child: Padding(
                padding: buttonTextPadding,
                child: Text(
                  AppLocalizations.of(context).shrineNextButtonCaption,
                  style: TextStyle(
                      letterSpacing: letterSpacingOrNone(largeLetterSpacing)),
                ),
              ),
              onPressed: () => onNext(),
            ),
          ],
        ),
      ],
    );
  }
}

class PrimaryColorOverride extends StatelessWidget {
  const PrimaryColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(primaryColor: color),
    );
  }
}
