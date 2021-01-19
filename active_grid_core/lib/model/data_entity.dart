part of active_grid_model;

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
