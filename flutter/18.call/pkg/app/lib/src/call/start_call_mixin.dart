import 'package:app/core.dart';
import 'package:app/model.dart' as Model;
import 'package:app/src/app_services/app_services.dart';
import 'package:app/src/call/call.dart';

mixin StartCallMixin on Widget {
  startVoiceCall(BuildContext context, String identity) {
    final options = Model.CallOptions(
      identity: identity,
      type: Model.CallType.voice,
    );
    _startCall(context, options);
  }

  startVideoCall(BuildContext context, String identity) {
    final options = Model.CallOptions(
      identity: identity,
      type: Model.CallType.video,
    );
    _startCall(context, options);
  }

  _startCall(BuildContext context, Model.CallOptions options) {
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
