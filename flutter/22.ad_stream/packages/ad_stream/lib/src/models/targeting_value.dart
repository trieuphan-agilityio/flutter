import 'package:equatable/equatable.dart';

enum TargetingType {
  passengerGender,
  passengerAgeRange,
  keyword,
  area,
  latLng,
  power,
  battery,
  connectivity,
  deviceCategory,
  deviceCapability
}

/// Targeting narrows who sees ads and helps advertisers reach
/// an intended audience or demographic with their campaigns.
/// Targeting helps to build expressions that determine how and
/// where ads serve to reflect the goals of the advertiser.
///
/// There are several targeting types, include:
///  - Consumer Info: choose age range, gender, speaking language.
///  - Keywords: Sport, Travel, Spa, etc.
///  - Point of Interest: Area, City, District.
///  - [*] Connectivity: Cable, Carrier, Wi-Fi, Unknown
///  - [*] Device category: Connected TV, Display Panel, Tablet
///
/// [*]: not support for now.
///
abstract class TargetingValue {
  TargetingType get type;
}

class PassengerAgeRange with EquatableMixin implements TargetingValue {
  final int from;
  final int to;

  const PassengerAgeRange(this.from, this.to);

  List<Object> get props => [from, to];

  TargetingType get type => TargetingType.passengerAgeRange;
}

class PassengerGender with EquatableMixin implements TargetingValue {
  final String gender;

  PassengerGender._(this.gender);

  static PassengerGender male = PassengerGender._('male');
  static PassengerGender female = PassengerGender._('female');
  static PassengerGender unknown = PassengerGender._('unknown');

  List<Object> get props => [gender];

  TargetingType get type => TargetingType.passengerGender;
}

class Keyword with EquatableMixin implements TargetingValue {
  final String keyword;

  const Keyword(this.keyword);

  List<Object> get props => [keyword];

  TargetingType get type => TargetingType.keyword;
}

class LatLng with EquatableMixin implements TargetingValue {
  final double lat;
  final double lng;

  const LatLng(this.lat, this.lng);

  List<Object> get props => [lat, lng];

  TargetingType get type => TargetingType.latLng;

  @override
  String toString() {
    return 'LatLng{lat: $lat, lng: $lng}';
  }
}

class Area with EquatableMixin implements TargetingValue {
  final String name;

  const Area(this.name);

  List<Object> get props => [name];

  TargetingType get type => TargetingType.area;
}

/// TargetingValues is the abstraction of the collection of TargetingValue
/// A targeting type can have more than one TargetingValue,
/// for example: Advertiser want to target to multiple areas.
class TargetingValues {
  Map<TargetingType, List<TargetingValue>> valuesMap;

  add(TargetingValue value) {
    if (valuesMap.containsKey(value.type)) {
      valuesMap[value.type].add(value);
    } else {
      valuesMap[value.type] = [value];
    }
  }

  addAll(TargetingType type, List<TargetingValue> values) {
    for (final value in values) {
      add(value);
    }
  }
}
