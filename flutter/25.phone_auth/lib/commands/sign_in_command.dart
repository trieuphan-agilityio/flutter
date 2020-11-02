import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'abstract_command.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignInWithEmailCommand extends AbstractCommand {
  SignInWithEmailCommand(BuildContext c) : super(c);

  Future<bool> execute(
    String email,
    String password, {
    bool silentSignIn = false,
  }) async {
    try {
      final UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User user = cred.user;
      authModel.email = user.email;

      return true;
    } catch (e) {
      print("Error!");
      print(e);
      return false;
    }
  }
}
