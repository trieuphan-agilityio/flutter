import 'dart:io';

import 'package:app/core.dart';
import 'package:flutter/services.dart';

class MyVideoTrack extends StatelessWidget {
  /// Participant identity
  final String identity;

  /// Recommend for front camera
  final bool shouldUseMirror;

  const MyVideoTrack({Key key, this.identity, this.shouldUseMirror})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final creationParams = {
      'isRemoteParticipant': false,
      'mirror': shouldUseMirror,
    };

    if (Platform.isAndroid) {
      return AndroidView(
        key: const ValueKey('local_participant_view'),
        viewType: 'com.example/participant_view',
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return UiKitView(
        key: const ValueKey('local_participant_view'),
        viewType: 'com.example/participant_view',
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (viewId) => print('created view'),
      );
    }
  }
}
