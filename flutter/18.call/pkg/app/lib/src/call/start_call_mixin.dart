import 'package:app/src/app_services/app_services.dart';
import 'package:app/src/call/call.dart';
import 'package:flutter/material.dart';
import 'package:app/core.dart';

mixin StartCallMixin on Widget {
  startVoiceCall(BuildContext context, String identity) {
    final options = CallOptions(identity: identity, isVideoCall: true);
    final appServices = AppServices.of(context);

    return Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return Call(api: appServices.videoCallApi, callOptions: options);
        },
      ),
    );
  }

  startVideoCall(BuildContext context, String identity) {
    final options = CallOptions(identity: identity, isVideoCall: false);
    final appServices = AppServices.of(context);

    return Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return Call(api: appServices.videoCallApi, callOptions: options);
        },
      ),
    );
  }
}
