part of active_grid_model;

/// The Data Types that are available in Active Grid
enum DataType {
  /// Type to display [String]
  text,

  /// Type to display [DateTime]
  dateTime,

  /// Type to display [DateTime] without the option to adjust the Time part
  date,

  /// Type to display [int] numbers
  integer,

  /// Type to display [bool] values
  checkbox,
}

/// Returns [DataType] that matches [schema] and [propertyName]
///
/// throws [ArgumentError] if [propertyName] is not present in [schema]
/// throws [ArgumentError] if DataType is not supported yet
DataType dataTypeFromSchema({dynamic schema, String propertyName}) {
  final properties = schema['properties'][propertyName];
  if (properties == null) {
    throw ArgumentError('No Schema Entry found for $propertyName');
  }
  final schemaType = properties['type'];
  final format = properties['format'];
  switch (schemaType) {
    case 'string':
      switch (format) {
        case 'date-time':
          return DataType.dateTime;
        case 'date':
          return DataType.date;
      }
      return DataType.text;
    case 'integer':
      return DataType.integer;
    case 'boolean':
      return DataType.checkbox;
    default:
      throw ArgumentError(
          'No according DataType found. Supported DataTypes are ${DataType.values}');
  }
}

abstract class DataEntity<T, S> {
  T value;

  S get schemaValue;

  @override
  String toString() {
    return '$runtimeType(value: $value)}';
  }

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType &&
        value == (other as DataEntity).value;
  }

  @override
  int get hashCode => toString().hashCode;
}

class StringDataEntity extends DataEntity<String, String> {
  StringDataEntity([this.value]);

  @override
  String value;

  @override
  String get schemaValue => value;
}

class DateTimeDataEntity extends DataEntity<DateTime, String> {
  DateTimeDataEntity([this.value]);

  @override
  DateTime value;

  DateTimeDataEntity.fromJson(dynamic json) {
    if (json != null) {
      value = DateTime.parse(json);
    }
  }

  @override
  String get schemaValue => value?.toIso8601String();
}

class DateDataEntity extends DataEntity<DateTime, String> {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  DateDataEntity([this.value]);

  @override
  DateTime value;

  DateDataEntity.fromJson(dynamic json) {
    if (json != null) {
      value = _dateFormat.parse(json);
    }
  }

  @override
  String get schemaValue => value != null ? _dateFormat.format(value) : null;
}

class BooleanDataEntity extends DataEntity<bool, bool> {
  BooleanDataEntity([value]) {
    this.value = value ?? false;
  }

  @override
  bool value;

  @override
  bool get schemaValue => value;
}

class IntegerDataEntity extends DataEntity<int, int> {
  IntegerDataEntity([this.value]);

  @override
  int value;

  @override
  int get schemaValue => value;
}
