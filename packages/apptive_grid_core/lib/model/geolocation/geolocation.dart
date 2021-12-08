part of apptive_grid_model;

/// Object representing a Geolocation by [latitude] and [longitude]
class Geolocation {
  /// Creates a new [Geolocation] with [latitude] and [longitude]
  const Geolocation({required this.latitude, required this.longitude});

  /// geographic coordinate that specifies the north–south position of this [Geolocation]
  final double latitude;
  /// geographic coordinate that specifies the east-west position of this [Geolocation]
  final double longitude;

  @override
  String toString() {
    return 'Geolocation(latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return other is Geolocation &&
    latitude == other.latitude &&
    longitude == other.longitude;
  }

  @override
  int get hashCode => toString().hashCode;
}