import 'package:apptive_grid_core/apptive_grid_core.dart';

/// Object representing a postal address
class Address {
  /// Creates a new [Address]
  const Address({
    this.line1,
    this.line2,
    this.city,
    this.postCode,
    this.state,
    this.country,
    this.geoLocation,
  });

  /// Creates a new Address from a [json] response
  factory Address.fromJson(dynamic json) {
    if (json case Map<String, dynamic> map) {
      return Address(
        line1: map['line1'] as String?,
        line2: map['line2'] as String?,
        city: map['city'] as String?,
        postCode: map['postCode'] as String?,
        state: map['state'] as String?,
        country: map['country'] as String?,
        geoLocation: map['geoLocation'] != null
            ? Geolocation.fromJson(map['geoLocation'])
            : null,
      );
    } else {
      throw ArgumentError.value(
        json,
        'Invalid json format for parsing Address',
      );
    }
  }

  /// First line of the address, usually street and house number
  final String? line1;

  /// Second line of the address, e.g. apartment or suite
  final String? line2;

  /// City of the address
  final String? city;

  /// Postal/ZIP code of the address
  final String? postCode;

  /// State/region of the address
  final String? state;

  /// Country of the address
  final String? country;

  /// Geographic coordinates of the address
  final Geolocation? geoLocation;

  /// Creates a json map expected by the server
  Map<String, dynamic> toJson() => {
        if (line1 != null) 'line1': line1,
        if (line2 != null) 'line2': line2,
        if (city != null) 'city': city,
        if (postCode != null) 'postCode': postCode,
        if (state != null) 'state': state,
        if (country != null) 'country': country,
        if (geoLocation != null) 'geoLocation': geoLocation!.toJson(),
      };

  /// Creates a copy of this [Address] with the given fields replaced
  Address copyWith({
    String? line1,
    String? line2,
    String? city,
    String? postCode,
    String? state,
    String? country,
    Geolocation? geoLocation,
  }) =>
      Address(
        line1: line1 ?? this.line1,
        line2: line2 ?? this.line2,
        city: city ?? this.city,
        postCode: postCode ?? this.postCode,
        state: state ?? this.state,
        country: country ?? this.country,
        geoLocation: geoLocation ?? this.geoLocation,
      );

  @override
  String toString() {
    return 'Address(line1: $line1, line2: $line2, city: $city, postCode: $postCode, state: $state, country: $country, geoLocation: $geoLocation)';
  }

  @override
  bool operator ==(Object other) {
    return other is Address &&
        line1 == other.line1 &&
        line2 == other.line2 &&
        city == other.city &&
        postCode == other.postCode &&
        state == other.state &&
        country == other.country &&
        geoLocation == other.geoLocation;
  }

  @override
  int get hashCode => Object.hash(
        line1,
        line2,
        city,
        postCode,
        state,
        country,
        geoLocation,
      );
}
