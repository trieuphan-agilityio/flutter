import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'abstract_command.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

/// Create an user profile with Email & password.
/// Phone verification supposes to be the next step after creating successully.
class SignUpWithEmailCommand extends AbstractCommand {
  SignUpWithEmailCommand(BuildContext c) : super(c);

  Future<bool> execute(String email, String password) async {
    try {
      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
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
