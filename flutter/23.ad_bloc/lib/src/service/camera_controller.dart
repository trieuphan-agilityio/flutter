import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/model.dart';
import 'debugger_factory.dart';

abstract class CameraController {
  Future<Photo> capture();
}

class CameraControllerImpl implements CameraController {
  CameraControllerImpl({CameraDebugger debugger}) : _cameraDebugger = debugger;

  final CameraDebugger _cameraDebugger;

  Future<Photo> capture() async {
    if (_cameraDebugger == null) {
      // FIXME photo taken by the camera.
      return Photo('sample/file.path');
    }

    return Photo(_cameraDebugger.filePath);
  }
}
