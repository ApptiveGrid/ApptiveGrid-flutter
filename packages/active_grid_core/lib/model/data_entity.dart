part of active_grid_model;

/// Model representing a DataEntry from ActiveGrid
///
/// [T] type of the data used in Flutter
/// [S] type used when sending Data back
abstract class DataEntity<T, S> {
  /// The value of the Entity
  T? value;

  /// The Value that is used when sending data back to the server. Matching against the schema
  S? get schemaValue;

  @override
  String toString() {
    return '$runtimeType(value: $value)}';
  }

  @override
  bool operator ==(Object other) {
    return other is DataEntity<T, S> &&
        runtimeType == other.runtimeType &&
        value == (other).value;
  }

  @override
  int get hashCode => toString().hashCode;
}

/// [DataEntity] representing [String] Objects
class StringDataEntity extends DataEntity<String, String> {
  /// Creates a new StringDataEntity Object with value [value]
  StringDataEntity([this.value]);

  @override
  String? value;

  @override
  String? get schemaValue => value;
}

/// [DataEntity] representing [DateTime] Objects
class DateTimeDataEntity extends DataEntity<DateTime, String> {
  /// Creates a new DateTimeDataEntity Object with value [value]
  DateTimeDataEntity([this.value]);

  /// Creates a new DateTimeDataEntity Object from json
  /// [json] needs to be a Iso8601String
  DateTimeDataEntity.fromJson(dynamic json) {
    if (json != null) {
      value = DateTime.parse(json);
    }
  }

  @override
  DateTime? value;

  /// Returns [value] as a Iso8601 Date String
  @override
  String? get schemaValue => value?.toIso8601String();
}

/// [DataEntity] representing a Date
/// Internally this is using [DateTime] ignoring the Time Part
class DateDataEntity extends DataEntity<DateTime, String> {
  /// Creates a new DateTimeDataEntity Object with value [value]
  DateDataEntity([this.value]);

  /// Creates a new DateTimeDataEntity Object from json
  /// [json] needs to be a Date String with Format yyyy-MM-dd
  DateDataEntity.fromJson(dynamic json) {
    if (json != null) {
      value = _dateFormat.parse(json);
    }
  }

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  DateTime? value;

  /// Returns [value] formatted to yyyy-MM-dd
  @override
  String? get schemaValue => value != null ? _dateFormat.format(value!) : null;
}

/// [DataEntity] representing [boolean] Objects
class BooleanDataEntity extends DataEntity<bool, bool> {
  /// Creates a new BooleanDataEntity Object
  BooleanDataEntity([value]) {
    this.value = value ?? false;
  }

  /// defaults to false
  @override
  bool? value;

  @override
  bool? get schemaValue => value;
}

/// [DataEntity] representing [int] Objects
class IntegerDataEntity extends DataEntity<int, int> {
  /// Creates a new IntegerDataEntity Object
  IntegerDataEntity([this.value]);

  @override
  int? value;

  @override
  int? get schemaValue => value;
}

/// [DataEntity] representing an enum like Object
class EnumDataEntity extends DataEntity<String, String> {
  /// Creates a new EnumDataEntity Object with [value] out of possible [options]
  EnumDataEntity({this.value, this.options = const []});

  @override
  String? value;

  /// Possible options of the Data Entity
  List<String> options;

  @override
  String? get schemaValue => value;

  @override
  String toString() {
    return '$runtimeType(value: $value, values: $options)}';
  }

  @override
  bool operator ==(Object other) {
    return other is EnumDataEntity &&
        value == (other).value &&
        f.listEquals(options, (other).options);
  }

  @override
  int get hashCode => toString().hashCode;
}
