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

  String toConstructableString();
}

class PassengerAgeRange implements TargetingValue {
  final int from;
  final int to;

  const PassengerAgeRange(this.from, this.to);

  TargetingType get type => TargetingType.passengerAgeRange;

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

extension TargetPassengerAgeRange on Iterable<PassengerAgeRange> {
  /// An utility to verify if age ranges detected in [AppBloc] match with
  /// the targeting age ranges of an Ad.
  bool isMatched(Iterable<PassengerAgeRange> targetingValues) {
    int requiredMatching = this.length;
    // In order to match targeting values of Passenger's Age Range,
    // the detected age ranges must be covered by targeting values.
    for (final ageRange in this) {
      for (final targetingValue in targetingValues) {
        if (targetingValue.from <= ageRange.from &&
            targetingValue.to >= ageRange.to) {
          requiredMatching--;
        }
      }
    }
    return requiredMatching == 0;
  }
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

extension TargetPassengerGender on Iterable<PassengerGender> {
  /// An utility to verify if genders detected in [AppBloc] match with
  /// the targeting genders of an Ad.
  bool isMatched(Iterable<PassengerGender> targetingValues) {
    int requiredMatching = this.length;
    // In order to match targeting values of Passenger's Gender,
    // the detected genders must be covered by targeting values.
    for (final gender in this) {
      if (targetingValues.contains(gender)) requiredMatching--;
    }
    return requiredMatching == 0;
  }
}

class Keyword implements TargetingValue {
  final String keyword;

  const Keyword(this.keyword);

  TargetingType get type => TargetingType.keyword;

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

extension TargetKeyword on Iterable<Keyword> {
  /// An utility to verify if keywords detected in [AppBloc] match with
  /// the targeting keywords of an Ad.
  bool isMatched(Iterable<Keyword> targetingValues) {
    // no keyword it's considered as matched.
    if (this.length == 0) return true;

    // at least one keyword is matched, the targeting values are conformed.
    return this.toSet().intersection(targetingValues.toSet()).length > 0;
  }
}

class Area implements TargetingValue {
  final String name;

  const Area(this.name);

  TargetingType get type => TargetingType.area;

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

extension TargetArea on Iterable<Area> {
  /// An utility to verify if areas detected in [AppBloc] match with
  /// the targeting areas of an Ad.
  bool isMatched(Iterable<Area> targetingValues) {
    // (!) figure out if an area is in another area.
    return true;
  }
}
