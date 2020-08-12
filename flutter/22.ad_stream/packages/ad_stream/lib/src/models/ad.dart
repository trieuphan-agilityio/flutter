import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/models/creative.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Ad represent the details of an agreement between administrator and advertiser.
///
/// It contains high level information about the ad campaign, such as which
/// kind of presentation the Ad is, how long does it take to show up
/// in the screen, can the Ad skippable.
///
/// See also:
/// - [Creative] Presentation of an Ad.
class Ad {
  final String id;

  /// [Creative] defines how user will impress the Ad.
  final Creative creative;

  /// Number of TimeBlock is assigned to this Ad to display Creative on.
  /// Typically 1 TimeBlock is 15 seconds.
  final int timeBlocks;

  /// Skippable ads allow viewers to skip ads after 6 seconds if they wish.
  /// Advertiser specify the duration limit for skippable ads.
  ///
  /// Zero value indicates that ad cannot be skipped.
  final int canSkipAfter;

  /// Advertiser supposes to buy keywords for the Ad. Once these keywords
  /// are matched with the audience, this Ad will be scheduled to display.
  final List<Keyword> targetingKeywords;

  /// Same as [targetingKeywords], this property help Advertiser target Ad to
  /// different geographic locations.
  ///
  /// Typically, Ad Server will help to figure out the polygon of these [Area]s.
  /// It can help the device verify [LatLng] value against these [Area]s faster.
  final List<Area> targetingAreas;

  bool get isSkippable => canSkipAfter == 0;

  bool get isReady => creative.filePath.isNotEmpty;

  /// Version of the Ad. It will be sent back to Ad Server to sync up with new,
  /// updated and removed Ads.
  final int version;

  final DateTime createdAt;
  final DateTime lastModifiedAt;

  Ad({
    @required this.id,
    @required this.creative,
    @required this.timeBlocks,
    @required this.canSkipAfter,
    @required this.targetingKeywords,
    @required this.targetingAreas,
    @required this.version,
    @required this.createdAt,
    @required this.lastModifiedAt,
  });

  @override
  String toString() {
    return 'Ad{id: $id'
        ', creative: $creative'
        ', timeBlocks: $timeBlocks'
        ', canSkipAfter: $canSkipAfter'
        ', targetingKeywords: $targetingKeywords'
        ', targetingAreas: $targetingAreas'
        ', version: $version'
        ', createdAt: $createdAt'
        ', lastModifiedAt: $lastModifiedAt}';
  }
}

/// A excerpt of [Ad] contains id and version.
class AdVersion {
  final String id;
  final int version;

  AdVersion(this.id, this.version);
}

class AdDiff {
  /// Compare two list of ads to figure out which ads have been added new,
  /// which one have been update and which one have been removed.
  static AdChangeSet diff(List<Ad> source, List<Ad> other) {
    List<Ad> newAds;
    List<Ad> updatedAds = [];
    List<String> removedAds = [];

    for (final ad in source) {
      // indicates whether ad has been removed from the list or not.
      // if so it would be added to the removed list.
      bool isRemoved = true;

      for (final otherAd in other) {
        if (ad.id == otherAd.id) {
          isRemoved = false;
          if (ad.version < otherAd.version) {
            updatedAds.add(otherAd);
          }
        }
      }

      if (isRemoved) {
        removedAds.add(ad.id);
      }
    }

    newAds = other.toSet().difference(source.toSet()).toList();

    return AdChangeSet(
      newAds: newAds,
      updatedAds: updatedAds,
      removedAds: removedAds,
    );
  }
}

class AdChangeSet {
  final List<Ad> newAds;
  final List<Ad> updatedAds;
  final List<String> removedAds;

  int get numOfNewAds => newAds.length;
  int get numOfUpdatedAds => updatedAds.length;
  int get numOfRemovedAds => removedAds.length;

  AdChangeSet({this.newAds, this.updatedAds, this.removedAds});
}
