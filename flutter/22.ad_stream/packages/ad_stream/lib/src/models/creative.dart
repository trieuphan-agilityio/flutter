import 'package:meta/meta.dart';

@immutable
abstract class Creative {
  String get id;

  /// Represent for Order that contains this Creative.
  /// It's used for ad analysis purpose.
  String get orderId;

  /// A hash string indicates whether Creative has changed or not,
  /// usually it's a md5 string.
  /// It could potential be used for verifying the integrity of the files.
  String get tag;
}

class ImageCreative implements Creative {
  final String id;
  final String orderId;
  final String tag;
  final String url;

  ImageCreative(this.id, this.orderId, this.tag, this.url);
}

class YoutubeCreative implements Creative {
  final String id;
  final String orderId;
  final String tag;
  final String url;

  YoutubeCreative(this.id, this.orderId, this.tag, this.url);
}

class VideoCreative implements Creative {
  final String id;
  final String orderId;
  final String tag;
  final String url;
  final String format;

  VideoCreative(this.id, this.orderId, this.tag, this.url, this.format);
}

class Html5ZipCreative implements Creative {
  final String id;
  final String orderId;
  final String tag;
  final String url;

  Html5ZipCreative(this.id, this.orderId, this.tag, this.url);
}
