import 'package:ad_stream/src/modules/base/debugger.dart';
import 'package:flutter/foundation.dart';

import '../photo.dart';

abstract class CameraDebugger {
  /// Specify a [Photo] to emit on [value$]
  usePhoto(Photo photo);

  /// Photo was "captured" by this debugger
  Photo get photo;

  /// Get notification about the status of the debugger
  ValueListenable<bool> get isOn;

  /// Allow toggling debugger on the flight.
  toggle([bool newValue]);
}

class CameraDebuggerImpl with DebuggerMixin implements CameraDebugger {
  Photo debuggerPhoto;

  Photo get photo => debuggerPhoto;

  usePhoto(Photo photo) {
    toggle(true);
    debuggerPhoto = photo;
  }
}
