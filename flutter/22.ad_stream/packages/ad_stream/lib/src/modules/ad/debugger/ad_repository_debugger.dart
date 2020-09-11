import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/base/debugger.dart';
import 'package:rxdart/rxdart.dart';

abstract class AdRepositoryDebugger implements Debugger<List<Ad>> {
  /// Set the list of ads that has creatives were downloaded
  setAds(Iterable<Ad> ads);
}

class AdRepositoryDebuggerImpl
    with DebuggerMixin
    implements AdRepositoryDebugger {
  /// Produces [ads$] stream.
  final BehaviorSubject<List<Ad>> ads$Controller;

  /// Produces [downloadingAds$] stream.
  final BehaviorSubject<List<Ad>> downloadingAds$Controller;

  AdRepositoryDebuggerImpl()
      : ads$Controller = BehaviorSubject<List<Ad>>.seeded(const []),
        downloadingAds$Controller = BehaviorSubject<List<Ad>>.seeded(const []);

  setAds(Iterable<Ad> ads) {
    ads$Controller.add(ads);
  }

  Stream<List<Ad>> get ads$ => ads$Controller.stream;

  Stream<List<Ad>> get downloadingAds$ => downloadingAds$Controller.stream;

  Stream<List<Keyword>> get keywords$ {
    return ads$.flatMap<List<Keyword>>((ads) {
      if (ads.length == 0) return Stream.empty();
      return Stream.value(ads.targetingKeywords);
    });
  }

  Stream<List<Ad>> get value$ => ads$;
}
