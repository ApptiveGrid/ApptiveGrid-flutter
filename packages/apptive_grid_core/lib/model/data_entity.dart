part of apptive_grid_model;

/// Model representing a DataEntry from ApptiveGrid
///
/// [T] type of the data used in Flutter
/// [S] type used when sending Data back
abstract class DataEntity<T, S> {
  /// Create a new DataEntity with [value]
  DataEntity([this.value]);

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
  StringDataEntity([String? value]) : super(value);

  @override
  String? get schemaValue => value;
}

/// [DataEntity] representing [DateTime] Objects
class DateTimeDataEntity extends DataEntity<DateTime, String> {
  /// Creates a new DateTimeDataEntity Object with value [value]
  DateTimeDataEntity([DateTime? value]) : super(value);

  /// Creates a new DateTimeDataEntity Object from json
  /// [json] needs to be a Iso8601String
  factory DateTimeDataEntity.fromJson(dynamic json) {
    DateTime? jsonValue;
    if (json != null) {
      jsonValue = DateTime.parse(json).toLocal();
    }
    return DateTimeDataEntity(jsonValue);
  }

  /// Returns [value] as a Iso8601 Date String
  @override
  String? get schemaValue => value?.toUtc().toIso8601String();
}

/// [DataEntity] representing a Date
/// Internally this is using [DateTime] ignoring the Time Part
class DateDataEntity extends DataEntity<DateTime, String> {
  /// Creates a new DateTimeDataEntity Object with value [value]
  DateDataEntity([DateTime? value]) : super(value);

  /// Creates a new DateTimeDataEntity Object from json
  /// [json] needs to be a Date String with Format yyyy-MM-dd
  factory DateDataEntity.fromJson(dynamic json) {
    DateTime? jsonValue;
    if (json != null) {
      jsonValue = _dateFormat.parse(json);
    }
    return DateDataEntity(jsonValue);
  }

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  /// Returns [value] formatted to yyyy-MM-dd
  @override
  String? get schemaValue => value != null ? _dateFormat.format(value!) : null;
}

/// [DataEntity] representing [boolean] Objects
class BooleanDataEntity extends DataEntity<bool, bool> {
  /// Creates a new BooleanDataEntity Object
  BooleanDataEntity([bool? value = false]) : super(value ?? false);

  @override
  bool? get schemaValue => value;
}

/// [DataEntity] representing [int] Objects
class IntegerDataEntity extends DataEntity<int, int> {
  /// Creates a new IntegerDataEntity Object
  IntegerDataEntity([int? value]) : super(value);

  @override
  int? get schemaValue => value;
}

/// [DataEntity] representing [double] Objects
class DecimalDataEntity extends DataEntity<double, double> {
  /// Creates a new DecimalDataEntity Object
  DecimalDataEntity([num? value]) : super(value?.toDouble());

  @override
  double? get schemaValue => value;
}

/// [DataEntity] representing an enum like Object
class EnumDataEntity extends DataEntity<String, String> {
  /// Creates a new EnumDataEntity Object with [value] out of possible [options]
  EnumDataEntity({String? value, this.options = const {}}) : super(value);

  /// Possible options of the Data Entity
  Set<String> options;

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
        f.setEquals(options, (other).options);
  }

  @override
  int get hashCode => toString().hashCode;
}

/// [DataEntity] representing an enum like Object
class EnumCollectionDataEntity extends DataEntity<Set<String>, List<String>> {
  /// Creates a new EnumDataEntity Object with [value] out of possible [options]
  EnumCollectionDataEntity._(
      {required Set<String> value, this.options = const {}})
      : super(value);

  /// Creates a new EnumDataEntity Object with [value] out of possible [options]
  factory EnumCollectionDataEntity(
      {Set<String>? value, Set<String> options = const {}}) {
    return EnumCollectionDataEntity._(value: value ?? {}, options: options);
  }

  /// Possible options of the Data Entity
  Set<String> options;

  @override
  List<String>? get schemaValue =>
      value == null || value!.isEmpty ? null : value!.toList();

  @override
  String toString() {
    return '$runtimeType(value: $value, values: $options)}';
  }

  @override
  bool operator ==(Object other) {
    return other is EnumCollectionDataEntity &&
        f.setEquals(value, other.value) &&
        f.setEquals(options, other.options);
  }

  @override
  int get hashCode => toString().hashCode;
}

/// [DataEntity] representing an Object CrossReferencing to a different Grid
class CrossReferenceDataEntity extends DataEntity<String, dynamic> {
  /// Create a new CrossReference Data Entity
  CrossReferenceDataEntity({
    String? value,
    this.entityUri,
    required this.gridUri,
  }) : super(value);

  /// Creates a new CrossReferenceDataEntity from a Json Response
  factory CrossReferenceDataEntity.fromJson({
    required Map? jsonValue,
    required String gridUri,
  }) =>
      CrossReferenceDataEntity(
        value: jsonValue?['displayValue'],
        entityUri: jsonValue?['uri'] != null
            ? EntityUri.fromUri(jsonValue?['uri'])
            : null,
        gridUri: GridUri.fromUri(gridUri),
      );

  /// The [EntityUri] pointing to the Entity this is referencing
  EntityUri? entityUri;

  /// Pointing to the [Grid] this is referencing
  final GridUri gridUri;

  @override
  dynamic get schemaValue {
    if (value == null || entityUri == null) {
      return null;
    } else {
      return {'displayValue': value, 'uri': entityUri?.uriString};
    }
  }

  @override
  String toString() {
    return 'CrossReferenceDataEntity(displayValue: $value, entityUri: $entityUri, gridUri: $gridUri)}';
  }

  @override
  bool operator ==(Object other) {
    return other is CrossReferenceDataEntity &&
        value == other.value &&
        entityUri == other.entityUri &&
        gridUri == other.gridUri;
  }

  @override
  int get hashCode => toString().hashCode;
}

/// [DataEntity] representing an array of Attachments
class AttachmentDataEntity extends DataEntity<List<Attachment>, dynamic> {
  /// Create a new Attachment Data Entity
  AttachmentDataEntity([
    List<Attachment>? value,
  ]) : super(value ?? []);

  /// Creates a new AttachmentDataEntity from a Json Response
  factory AttachmentDataEntity.fromJson(
    List? jsonValue,
  ) =>
      AttachmentDataEntity(
        jsonValue
                ?.map((attachment) => Attachment.fromJson(attachment))
                .toList() ??
            [],
      );

  @override
  dynamic get schemaValue {
    if (value == null || value!.isEmpty) {
      return null;
    } else {
      return value!.map((e) => e.toJson()).toList();
    }
  }

  @override
  String toString() {
    return 'AttachmentDataEntity(attachments: $value)';
  }

  @override
  bool operator ==(Object other) {
    return other is AttachmentDataEntity && f.listEquals(value, other.value);
  }

  @override
  int get hashCode => toString().hashCode;
}
