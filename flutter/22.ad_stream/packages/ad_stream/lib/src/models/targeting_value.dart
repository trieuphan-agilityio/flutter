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

  /// If value is not stackable, new value would causes previous one is removed
  /// from the list when adding.
  ///
  /// Some values that are stackable such as [Keyword] which mean that on an trip
  /// [Keyword]s are collecting until passenger is dropped off.
  bool get isStackable;
}

class PassengerAgeRange with EquatableMixin implements TargetingValue {
  final int from;
  final int to;

  const PassengerAgeRange(this.from, this.to);

  List<Object> get props => [from, to];

  TargetingType get type => TargetingType.passengerAgeRange;

  bool get isStackable => false;

  @override
  String toString() {
    return 'PassengerAgeRange{from: $from, to: $to}';
  }
}

class PassengerGender with EquatableMixin implements TargetingValue {
  final String gender;

  PassengerGender._(this.gender);

  /// Gender is male when all passenger genders are detected as male.
  static PassengerGender male = PassengerGender._('male');

  /// Gender is female when all passenger genders are detected as female.
  static PassengerGender female = PassengerGender._('female');

  /// Gender is both when there are more than one passengers, and
  /// their genders are detected as both male and female.
  static PassengerGender both = PassengerGender._('both');

  static PassengerGender unknown = PassengerGender._('unknown');

  List<Object> get props => [gender];

  TargetingType get type => TargetingType.passengerGender;

  bool get isStackable => false;

  @override
  String toString() {
    return 'PassengerGender{gender: $gender}';
  }
}

class Keyword with EquatableMixin implements TargetingValue {
  final String keyword;

  const Keyword(this.keyword);

  List<Object> get props => [keyword];

  TargetingType get type => TargetingType.keyword;

  bool get isStackable => true;

  @override
  String toString() {
    return 'Keyword{keyword: $keyword}';
  }
}

class LatLng with EquatableMixin implements TargetingValue {
  final double lat;
  final double lng;

  const LatLng(this.lat, this.lng);

  List<Object> get props => [lat, lng];

  TargetingType get type => TargetingType.latLng;

  bool get isStackable => false;

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

  bool get isStackable => false;

  @override
  String toString() {
    return 'Area{name: $name}';
  }
}

/// TargetingValues is the abstraction of the collection of TargetingValue
/// A targeting type can have more than one TargetingValue,
/// for example: Advertiser want to target to multiple areas.
class TargetingValues {
  final Map<TargetingType, List<TargetingValue>> valuesMap = {};

  add(TargetingValue value) {
    if (valuesMap.containsKey(value.type) && value.isStackable) {
      valuesMap[value.type].add(value);
    } else {
      valuesMap[value.type] = [value];
    }
  }

  addAll(List<TargetingValue> values) {
    for (final value in values) {
      add(value);
    }
  }

  /// Remove all targeting values.
  clear() {
    valuesMap.clear();
  }

  @override
  String toString() {
    return 'TargetingValues{valuesMap: $valuesMap}';
  }
}
