import 'package:meta/meta.dart';

class CreativeType {
  final String name;

  const CreativeType._(this.name);

  static const CreativeType image = CreativeType._('image');
  static const CreativeType video = CreativeType._('video');
  static const CreativeType html = CreativeType._('html');
  static const CreativeType youtube = CreativeType._('youtube');
  static const CreativeType screensaver = CreativeType._('screensaver');

  @override
  String toString() {
    return 'CreativeType{name: $name}';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CreativeType && name == other.name;
  }

  @override
  int get hashCode => name.hashCode;
}

/// A creative is the ad users see on the app.
/// Creative can be image, video, and other formats that get delivered to users.
@immutable
abstract class Creative {
  String get id;

  /// First 6 chars of Id, useful for displaying on debugging.
  String get shortId;

  CreativeType get type;

  /// Location of the file in local filesystem. Its presentation indicates that
  /// the creative have been downloaded and ready to serve.
  ///
  /// There are two special use cases:
  ///
  /// 1. In [YoutubeCreative] [filePath] is assigned with urlPath value which
  ///    indicates that it doesn't need to download, and always ready to serve.
  ///
  /// 2. In [HtmlCreative] [filePath] is assigned to the folder contains Html
  ///    bundle instead of a file.
  String get filePath;

  String toConstructableString();
}

class ImageCreative implements Creative {
  final String id;
  final CreativeType type;
  final String urlPath;
  final String filePath;

  String get shortId => id.substring(0, 7);

  const ImageCreative({
    @required this.id,
    @required this.urlPath,
    @required this.filePath,
  }) : type = CreativeType.image;

  ImageCreative copyWith({
    String id,
    String urlPath,
    String filePath,
  }) {
    return ImageCreative(
      id: id ?? this.id,
      urlPath: urlPath ?? this.urlPath,
      filePath: filePath ?? this.filePath,
    );
  }

  String toConstructableString() {
    return 'const ImageCreative(id: "$id"'
        ', urlPath: "$urlPath"'
        ', filePath: "$filePath")';
  }

  @override
  String toString() {
    return 'ImageCreative{id: $id, urlPath: $urlPath, filePath: $filePath}';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ImageCreative &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            urlPath == other.urlPath &&
            filePath == other.filePath;
  }

  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ urlPath.hashCode ^ filePath.hashCode;
}

class YoutubeCreative implements Creative {
  final String id;
  final CreativeType type;
  final String urlPath;
  final String filePath;

  /// Video length in seconds
  final int videoLength;

  String get shortId => id.substring(0, 5);

  const YoutubeCreative({
    @required this.id,
    @required this.urlPath,
    @required this.videoLength,
  })  : type = CreativeType.youtube,
        filePath = urlPath;

  YoutubeCreative copyWith({
    String id,
    String urlPath,
    String videoLength,
  }) {
    return YoutubeCreative(
      id: id ?? this.id,
      urlPath: urlPath ?? this.urlPath,
      videoLength: videoLength ?? this.videoLength,
    );
  }

  String toConstructableString() {
    return 'const YoutubeCreative(id: "$id"'
        ', urlPath: "$urlPath"'
        ', videoLength: $videoLength)';
  }

  @override
  String toString() {
    return 'YoutubeCreative{id: $id'
        ', urlPath: $urlPath'
        ', filePath: $filePath'
        ', videoLength: $videoLength}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YoutubeCreative &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          urlPath == other.urlPath &&
          filePath == other.filePath &&
          videoLength == other.videoLength;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      urlPath.hashCode ^
      filePath.hashCode ^
      videoLength.hashCode;
}

class VideoCreative implements Creative {
  final String id;
  final CreativeType type;
  final String urlPath;
  final String filePath;

  /// .mp4, .avi.
  final String format;

  /// Video length in seconds.
  final int videoLength;

  /// Estimated size of the video (kB)
  final int fileSize;

  String get shortId => id.substring(0, 5);

  const VideoCreative({
    @required this.id,
    @required this.urlPath,
    @required this.filePath,
    @required this.format,
    @required this.videoLength,
    @required this.fileSize,
  }) : type = CreativeType.video;

  VideoCreative copyWith({
    String id,
    String urlPath,
    String filePath,
    String format,
    int videoLength,
    int fileSize,
  }) {
    return VideoCreative(
      id: id ?? this.id,
      urlPath: urlPath ?? this.urlPath,
      filePath: filePath ?? this.filePath,
      format: format ?? this.format,
      videoLength: videoLength ?? this.videoLength,
      fileSize: fileSize ?? this.fileSize,
    );
  }

  String toConstructableString() {
    return 'VideoCreative(id: "$id"'
        ', urlPath: "$urlPath"'
        ', filePath: "$filePath"'
        ', format: "$format"'
        ', videoLength: $videoLength'
        ', fileSize: $fileSize)';
  }

  @override
  String toString() {
    return 'VideoCreative{id: $id'
        ', urlPath: $urlPath'
        ', filePath: $filePath'
        ', format: $format'
        ', videoLength: $videoLength'
        ', fileSize: $fileSize}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoCreative &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          urlPath == other.urlPath &&
          filePath == other.filePath &&
          format == other.format &&
          videoLength == other.videoLength &&
          fileSize == other.fileSize;

  @override
  int get hashCode =>
      id.hashCode ^
      urlPath.hashCode ^
      filePath.hashCode ^
      format.hashCode ^
      videoLength.hashCode ^
      fileSize.hashCode;
}

class HtmlCreative implements Creative {
  final String id;
  final CreativeType type;

  /// [urlPath] is the location of the Zip file on Asset Server. It contains
  /// a Html bundle, inside are index.html, images and css files.
  final String urlPath;

  /// [filePath] is the location of the root folder in local filesystem.
  /// It must contain an index.html file in the root folder.
  final String filePath;

  /// Estimated size of the Zip file bundle.
  final int fileSize;

  String get shortId => id.substring(0, 5);

  const HtmlCreative({
    @required this.id,
    @required this.urlPath,
    @required this.filePath,
    @required this.fileSize,
  }) : type = CreativeType.html;

  HtmlCreative copyWith({
    String id,
    String urlPath,
    String filePath,
    int fileSize,
  }) {
    return HtmlCreative(
      id: id ?? this.id,
      urlPath: urlPath ?? this.urlPath,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
    );
  }

  String toConstructableString() {
    return 'HtmlCreative(id: "$id"'
        ', urlPath: "$urlPath"'
        ', filePath: "$filePath"'
        ', fileSize: $fileSize)';
  }

  @override
  String toString() {
    return 'HtmlCreative{id: $id'
        ', urlPath: $urlPath'
        ', filePath: $filePath'
        ', fileSize: $fileSize}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HtmlCreative &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          urlPath == other.urlPath &&
          filePath == other.filePath &&
          fileSize == other.fileSize;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      urlPath.hashCode ^
      filePath.hashCode ^
      fileSize.hashCode;
}

class Screensaver implements Creative {
  const Screensaver();

  String get id => 'screensaver';

  String get shortId => 'screensaver';

  CreativeType get type => CreativeType.screensaver;

  String get filePath => 'assets/screensaver.jpg';

  String toConstructableString() {
    return 'Screensaver(id: "$id"'
        ', shortId: "$shortId"'
        ', type: Screensaver.${type.name}'
        ', filePath: "$filePath")';
  }

  @override
  String toString() {
    return 'Screensaver{id: $id'
        ', shortId: $shortId'
        ', type: $type'
        ', filePath: $filePath}';
  }
}
