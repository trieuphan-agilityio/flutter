import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:ad_bloc/config.dart';
import 'package:ad_bloc/model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdState extends Equatable {
  /// If null display a placeholder
  final AdViewModel ad;

  const AdState([this.ad]);

  @override
  List<Object> get props => [ad];
}

class AdEvent extends Equatable {
  const AdEvent();

  @override
  List<Object> get props => [];
}

class AdStarted extends AdEvent {
  const AdStarted();
}

class AdSkipped extends AdEvent {
  const AdSkipped();
}

class AdFinished extends AdEvent {
  const AdFinished();
}

class AdBloc extends Bloc<AdEvent, AdState> {
  static AdBloc of(BuildContext context) {
    return BlocProvider.of<AdBloc>(context);
  }

  AdBloc(
    AdState initialState, {
    @required AdConfig adConfig,
    @required AppBloc appBloc,
  })  : _appBloc = appBloc,
        _adConfig = adConfig,
        super(initialState);

  final AppBloc _appBloc;
  final AdConfig _adConfig;

  @override
  Stream<AdState> mapEventToState(AdEvent evt) async* {
    if (evt is AdStarted || evt is AdSkipped || evt is AdFinished) {
      yield _pickAd(_appBloc.state.readyAds);
    }
  }

  AdState _pickAd(Iterable<Ad> ads) {
    final appState = _appBloc.state;
    final genders = appState.genders;
    final ageRanges = appState.ageRanges;
    final keywords = appState.keywords;

    final matchedAds = appState.readyAds.where((ad) {
      return genders.isMatched(ad.targetingGenders) &&
          ageRanges.isMatched(ad.targetingAgeRanges) &&
          keywords.isMatched(ad.targetingKeywords);
    });

    if (matchedAds.length == 0) {
      Log.debug('beating');

      // use default if there is no candidate
      return AdState(_adToAdViewModel(_adConfig.defaultAd));
    }

    // (!) It supposes to figure out which ad is best for displaying.
    // For now it blindly chooses ad by rotating the list.
    final Ad pickedAd = _rotateCreative(matchedAds);

    // once Ad was picked its priority order will be updated.
    _appBloc.add(
      ReadyAdsChanged(appState.readyAds.toList()
        ..remove(pickedAd)
        ..add(pickedAd.copyWith(
          displayPriority: appState.readyAds.length,
        ))),
    );

    final hasTargeting =
        genders.isNotEmpty || ageRanges.isNotEmpty && keywords.isNotEmpty;

    final genderStr = 'genders: [${genders.map((g) => g.gender).join(', ')}]';
    final ageStr =
        'age ranges: [${ageRanges.map((r) => "${r.from}-${r.to}").join(', ')}]';
    final keywordStr = 'keywords: [${keywords.join(', ')}]';

    Log.info('picked ${pickedAd.shortId}'
        '-${pickedAd.creative.shortId}'
        '-v${pickedAd.version}'
        '${hasTargeting ? ", with $genderStr, $ageStr, $keywordStr." : "."}');

    // choose this Ad for displaying
    return AdState(_adToAdViewModel(pickedAd));
  }

  /// A data structure for rotating creatives
  PriorityQueue<Ad> _displayingQueue = PriorityQueue<Ad>((ad1, ad2) {
    if (ad1.displayPriority < ad2.displayPriority) return 1;
    if (ad1.displayPriority > ad2.displayPriority) return -1;
    return 0;
  });

  /// Simple algorithm to rotate creatives
  Ad _rotateCreative(Iterable<Ad> ads) {
    // clean up the queue based on new the ads list
    for (final adInQueue in _displayingQueue.toList()) {
      if (!ads.contains(adInQueue)) {
        _displayingQueue.remove(adInQueue);
      }
    }

    for (final ad in ads) {
      if (!_displayingQueue.contains(ad)) {
        _displayingQueue.add(ad);
      }
    }

    // take the high priority ad which has a lowest `displayPriority` value.
    return _displayingQueue.removeFirst();
  }

  _adToAdViewModel(Ad ad) {
    return AdViewModel()
      ..id = ad.creative.shortId
      ..type = ad.creative.type
      ..duration = Duration(
        seconds: ad.timeBlocks * _adConfig.timeBlockToSecs,
      )
      ..canSkipAfter = ad.canSkipAfter
      ..isSkippable = ad.isSkippable
      ..filePath = ad.creative.filePath;
  }
}

class AdViewModel {
  String id;
  CreativeType type;

  /// duration indicates how long the ad should be displayed
  Duration duration;

  /// allow viewers to skip ads after `canSkipAfter` seconds if they wish
  int canSkipAfter;

  /// indicates whether ad is skippable
  bool isSkippable;
  String filePath;
}
