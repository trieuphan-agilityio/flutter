import 'dart:async';

import 'package:ad_stream/src/features/debugger/dashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_transform/stream_transform.dart';

/// Listen to the specific key sequence and open the debug dashboard.
/// Or long press on the hidden debug button which is typically placed at
/// [FloatingActionButtonLocation.centerFloat] of the Scaffold.
class DebugButton extends StatefulWidget {
  @override
  _DebugButtonState createState() => _DebugButtonState();
}

class _DebugButtonState extends State<DebugButton> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0,
      child: _KeySequenceListener(
        onKeyMatched: _openDebugDashboard,
        child: RawMaterialButton(
          key: const Key('debug_button'),
          onLongPress: _openDebugDashboard,
          onPressed: () {},
        ),
      ),
    );
  }

  _openDebugDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return DebugDashboard();
        },
      ),
    );
  }
}

/// use the pressed key sequence on volume keys to open debug dashboard
enum VolumeKey { up, down }

const _kKeySequenceToOpenDebugDashboard = [
  VolumeKey.up,
  VolumeKey.down,
  VolumeKey.up,
  VolumeKey.down,
];

class _KeySequenceListener extends StatefulWidget {
  final Widget child;
  final Function() onKeyMatched;

  const _KeySequenceListener(
      {Key key, @required this.child, @required this.onKeyMatched})
      : super(key: key);

  @override
  __KeySequenceListenerState createState() => __KeySequenceListenerState();
}

class __KeySequenceListenerState extends State<_KeySequenceListener> {
  StreamController<VolumeKey> _streamController;
  StreamSubscription<bool> _keySequenceSubscription;
  Function(RawKeyEvent) _listener;

  @override
  void initState() {
    _streamController = StreamController.broadcast();

    RawKeyboard.instance.addListener(_listener ??= (value) {
      final volumeKey = _getVolumeKey(value.logicalKey);
      if (volumeKey != null) {
        _streamController.add(volumeKey);
      }
    });

    /// Press the key sequence [_kKeySequenceToOpenDebugDashboard] constantly
    /// and wait for 1 second to open debug dashboard.
    ///
    _keySequenceSubscription = _streamController.stream
        .distinct()
        .debounceBuffer(Duration(seconds: 1))
        .map((keySequence) {
      return listEquals(keySequence, _kKeySequenceToOpenDebugDashboard);
    }).listen((bool yes) {
      if (yes) widget.onKeyMatched();
    });

    super.initState();
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_listener);
    _keySequenceSubscription?.cancel();
    _streamController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Convert logical keyboard key to the specific [VolumnKey].
/// Return null if keyboard key not match.
VolumeKey _getVolumeKey(LogicalKeyboardKey logicalKeyboardKey) {
  if (logicalKeyboardKey == LogicalKeyboardKey.audioVolumeUp)
    return VolumeKey.up;

  if (logicalKeyboardKey == LogicalKeyboardKey.audioVolumeDown)
    return VolumeKey.down;

  return null;
}
