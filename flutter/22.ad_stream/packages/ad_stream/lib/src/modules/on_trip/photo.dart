/// [Photo] was taken by [CameraController]. It contains a [filePath] indicates
/// local filesystem's path of the captured photo.
class Photo {
  /// Sometimes the photo is saved at cache folder so that it can be clean up by
  /// system's file manager.
  ///
  /// If the consumer use [Photo] and not seeing a valid [filePath], consumer
  /// should handle the error by itself.
  final String filePath;

  Photo(this.filePath);

  @override
  String toString() {
    return 'Photo{filePath: $filePath}';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is Photo && o.filePath == filePath;
  }

  @override
  int get hashCode => filePath.hashCode;
}
