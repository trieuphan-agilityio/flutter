import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'abstract_command.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

/// User proofs that their own a phone number.
class VerifyPhoneCommand extends AbstractCommand {
  VerifyPhoneCommand(BuildContext c) : super(c);

  Future<bool> execute(String phoneNumber) async {
    Completer<bool> completer = Completer();

    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (verificationCompleted) {
        print(
            '[VerifyPhoneCommand] verificationCompleted $verificationCompleted');
        completer.complete(true);
      },
      verificationFailed: (err) {
        print('[VerifyPhoneCommand] verificationFailed');
        print(err);
        completer.complete(false);
      },
      codeSent: (verificationId, forceResendingToken) {
        print(
            '[VerifyPhoneCommand] codeSent $verificationId | $forceResendingToken');
      },
      codeAutoRetrievalTimeout: (_) {
        print('[VerifyPhoneCommand] codeAutoRetrievalTimeout');
        // Time ran out and user still hasn't received the code yet.
        // Maybe a callback is called to inform user check connectivity or
        // retrieve if needs.
        completer.complete(false);
      },
    );

    return completer.future;
  }
}
