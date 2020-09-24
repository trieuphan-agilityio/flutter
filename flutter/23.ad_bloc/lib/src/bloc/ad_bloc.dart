import 'dart:collection';

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
    @required AppBloc appBloc,
    @required AdConfig adConfig,
  })  : _appBloc = appBloc,
        _adConfig = adConfig,
        super(initialState);

  final AppBloc _appBloc;
  final AdConfig _adConfig;

  @override
  Stream<AdState> mapEventToState(AdEvent evt) async* {
    if (evt is AdStarted) {
      yield _pickAd(_appBloc.state.readyAds);
    }

    if (evt is AdSkipped) {
      yield _pickAd(_appBloc.state.readyAds);
    }

    if (evt is AdFinished) {
      yield _pickAd(_appBloc.state.readyAds);
    }
  }

  @override
  close() async {
    _appBloc.close();
    super.close();
  }

  AdState _pickAd(Iterable<Ad> ads) {
    final genders = _appBloc.state.genders;
    final ageRanges = _appBloc.state.ageRanges;
    final keywords = _appBloc.state.keywords;

    final matchedAds = _appBloc.state.readyAds.where((ad) {
      return genders.isMatched(ad.targetingGenders) &&
          ageRanges.isMatched(ad.targetingAgeRanges) &&
          keywords.isMatched(ad.targetingKeywords);
    }).toList();

    if (matchedAds.length == 0) {
      Log.debug('beating');

      // use default if there is no candidate
      return AdState(_adToAdViewModel(_adConfig.defaultAd));
    }

    // (!) It supposes to figure out which ad is best for displaying.
    // For now it blindly chooses ad by rotating the list.
    final Ad pickedAd = _rotateCreative(matchedAds);

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
  Queue<Ad> _displayingQueue = Queue<Ad>();

  /// Simple algorithm to rotate creatives
  Ad _rotateCreative(Iterable<Ad> ads) {
    _displayingQueue.retainWhere((e) => ads.contains(e));
    for (final ad in ads) {
      if (!_displayingQueue.contains(ad)) {
        _displayingQueue.add(ad);
      }
    }
    return _displayingQueue.removeFirst();
  }

  _adToAdViewModel(Ad ad) {
    return AdViewModel(
      ad: ad,
      canSkipAfter: ad.canSkipAfter,
      isSkippable: ad.isSkippable,
      duration: Duration(
        seconds: ad.timeBlocks * _adConfig.timeBlockToSecs,
      ),
      displayedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }
}

@immutable
class AdViewModel extends Equatable {
  /// Original ad object uses for reference
  final Ad ad;

  /// duration indicates how long the ad should be displayed
  final Duration duration;

  /// allow viewers to skip ads after 5 seconds if they wish
  final int canSkipAfter;

  /// indicates whether ad is skippable
  final bool isSkippable;

  /// Time the ad was started displaying
  final int displayedAt;

  const AdViewModel({
    @required this.ad,
    @required this.duration,
    @required this.canSkipAfter,
    @required this.isSkippable,
    @required this.displayedAt,
  });

  @override
  List<Object> get props => [
        ad,
        duration,
        canSkipAfter,
        isSkippable,
        displayedAt,
      ];

  String get wellFormatString {
    return 'AdViewModel{\n  id: ${ad.creative.shortId}'
        ',\n  duration: ${duration.inSeconds}s'
        ',\n  isSkippable: $isSkippable'
        ',\n  canSkipAfter: ${canSkipAfter}s\n}';
  }
}
