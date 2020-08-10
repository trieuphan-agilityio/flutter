import 'package:meta/meta.dart';

@immutable
abstract class Creative {
  String get id;
}

class ImageCreative implements Creative {
  final String id;
  final String urlPath;
  final String filePath;

  ImageCreative(this.id, this.urlPath, this.filePath);
}

class YoutubeCreative implements Creative {
  final String id;
  final String urlPath;

  YoutubeCreative(this.id, this.urlPath);
}

class VideoCreative implements Creative {
  final String id;
  final String urlPath;
  final String format;
  final String filePath;

  VideoCreative(this.id, this.urlPath, this.format, this.filePath);
}

class Html5ZipCreative implements Creative {
  final String id;
  final String urlPath;
  final String folderPath;

  Html5ZipCreative(this.id, this.urlPath, this.folderPath);
}
