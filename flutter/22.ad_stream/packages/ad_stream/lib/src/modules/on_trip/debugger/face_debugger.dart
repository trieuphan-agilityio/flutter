import 'package:ad_stream/src/modules/base/debugger.dart';
import 'package:rxdart/rxdart.dart';

import '../face.dart';

abstract class FaceDebugger implements Debugger<List<Face>> {
  /// unset faces on stream
  noFace();

  /// pretent that faces have detected
  useFaces(List<Face> faces);
}

class FaceDebuggerImpl with DebuggerMixin implements FaceDebugger {
  FaceDebuggerImpl() : this._subject = BehaviorSubject.seeded([]);

  Stream<List<Face>> get value$ => _subject;

  noFace() {
    toggle(true);
    _subject.add([]);
  }

  useFaces(List<Face> faces) {
    toggle(true);
    _subject.add(faces);
  }

  BehaviorSubject<List<Face>> _subject;
}
