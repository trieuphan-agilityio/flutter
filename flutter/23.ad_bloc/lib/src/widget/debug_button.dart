import 'package:ad_bloc/base.dart';
import 'package:flutter/services.dart';

/// Listen to the specific key sequence and open the debug dashboard.
/// Or long press on the hidden debug button which is typically placed at
/// [FloatingActionButtonLocation.centerFloat] of the Scaffold.
class DebugButton extends StatefulWidget {
  const DebugButton({Key key}) : super(key: key);

  @override
  _DebugButtonState createState() => _DebugButtonState();
}

class _DebugButtonState extends State<DebugButton> {
  @override
  Widget build(BuildContext context) {
    return _KeySequenceListener(
      onKeyMatched: _openDebugDashboard,
      child: Opacity(
        opacity: 1,
        child: RawMaterialButton(
          key: const Key('debug_button'),
          onLongPress: _openDebugDashboard,
          onPressed: () {},
        ),
      ),
    );
  }

  _openDebugDashboard() {
    Navigator.pushReplacementNamed(context, '/debug');
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
  ValueChanged<RawKeyEvent> _handleKeyboardEvent;

  @override
  void initState() {
    _streamController = StreamController.broadcast();

    RawKeyboard.instance.addListener(_handleKeyboardEvent ??= (value) {
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
    RawKeyboard.instance.removeListener(_handleKeyboardEvent);
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
