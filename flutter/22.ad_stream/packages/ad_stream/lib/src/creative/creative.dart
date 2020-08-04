abstract class Creative {
  String get id;

  /// Represent for Order that contains this Creative.
  /// It's used for ad analysis purpose.
  String get orderId;

  Creative();

  factory Creative.youtube(String url) {
    return YoutubeCreative();
  }
}

class ImageCreative implements Creative {
  final String id;
  final String orderId;

  ImageCreative({this.id, this.orderId});
}

class YoutubeCreative implements Creative {
  final String id;
  final String orderId;

  YoutubeCreative({this.id, this.orderId});
}

class VideoCreative implements Creative {
  final String id;
  final String orderId;

  VideoCreative({this.id, this.orderId});
}

class Html5ZipCreative implements Creative {
  final String id;
  final String orderId;

  Html5ZipCreative({this.id, this.orderId});
}
