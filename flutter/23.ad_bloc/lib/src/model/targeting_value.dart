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

  String toConstructableString();
}

class PassengerAgeRange implements TargetingValue {
  final int from;
  final int to;

  const PassengerAgeRange(this.from, this.to);

  TargetingType get type => TargetingType.passengerAgeRange;

  /// If there are more than one passengers the targeting values should collect
  /// multiple values of passenger's age range.
  bool get isStackable => true;

  String toConstructableString() {
    return 'const PassengerAgeRange($from, $to)';
  }

  @override
  String toString() {
    return 'PassengerAgeRange{from: $from, to: $to}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PassengerAgeRange &&
          runtimeType == other.runtimeType &&
          from == other.from &&
          to == other.to;

  @override
  int get hashCode => from.hashCode ^ to.hashCode;
}

class PassengerGender implements TargetingValue {
  final String gender;

  const PassengerGender._(this.gender);

  /// Gender is male when all passenger genders are detected as male.
  static const PassengerGender male = PassengerGender._('male');

  /// Gender is female when all passenger genders are detected as female.
  static const PassengerGender female = PassengerGender._('female');

  static const PassengerGender unknown = PassengerGender._('unknown');

  TargetingType get type => TargetingType.passengerGender;

  /// If there are more than one passengers the targeting values should collect
  /// multiple values of passenger's gender.
  bool get isStackable => true;

  String toConstructableString() {
    return 'PassengerGender.$gender';
  }

  @override
  String toString() {
    return 'PassengerGender{gender: $gender}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PassengerGender &&
          runtimeType == other.runtimeType &&
          gender == other.gender;

  @override
  int get hashCode => gender.hashCode;
}

class Keyword implements TargetingValue {
  final String keyword;

  const Keyword(this.keyword);

  TargetingType get type => TargetingType.keyword;

  bool get isStackable => true;

  String toConstructableString() {
    return 'const Keyword("$keyword")';
  }

  @override
  String toString() {
    return 'Keyword{keyword: $keyword}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Keyword &&
          runtimeType == other.runtimeType &&
          keyword == other.keyword;

  @override
  int get hashCode => keyword.hashCode;
}

class LatLng implements TargetingValue {
  final double lat;
  final double lng;

  const LatLng(this.lat, this.lng);

  TargetingType get type => TargetingType.latLng;

  bool get isStackable => false;

  String toConstructableString() {
    return 'const LatLng("$lat", "$lng")';
  }

  @override
  String toString() {
    return 'LatLng{lat: $lat, lng: $lng}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLng &&
          runtimeType == other.runtimeType &&
          lat == other.lat &&
          lng == other.lng;

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode;
}

class Area implements TargetingValue {
  final String name;

  const Area(this.name);

  TargetingType get type => TargetingType.area;

  bool get isStackable => false;

  String toConstructableString() {
    return 'const Area("$name")';
  }

  @override
  String toString() {
    return 'Area{name: $name}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Area && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
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

  addAll(Iterable<TargetingValue> values) {
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TargetingValues &&
          runtimeType == other.runtimeType &&
          valuesMap == other.valuesMap;

  @override
  int get hashCode => valuesMap.hashCode;
}
