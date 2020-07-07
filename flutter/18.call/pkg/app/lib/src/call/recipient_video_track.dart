import 'dart:io';

import 'package:app/core.dart';
import 'package:flutter/services.dart';

class RecipientVideoTrack extends StatelessWidget {
  /// Participant identity
  final String identity;

  const RecipientVideoTrack({Key key, this.identity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final creationParams = {
      'isRemoteParticipant': true,
      'mirror': false,
    };

    if (Platform.isAndroid) {
      return AndroidView(
        key: const ValueKey('remote_participant_view'),
        viewType: 'com.example/participant_view',
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return UiKitView(
        key: const ValueKey('remote_participant_view'),
        viewType: 'com.example/participant_view',
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
  }
}
