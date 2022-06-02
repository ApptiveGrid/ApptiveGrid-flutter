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

/// Class for DataEntities that are support in Comparison Filters like [LesserThanFilter] and [GreaterThanFilter]
abstract class ComparableDataEntity<T, S> extends DataEntity<T, S> {
  /// Creates a new DataEntity with [value]
  ComparableDataEntity([super.value]);
}

/// Class for DataEntities that support Collection Filters like [AnyOfFilter], [AllOfFilter] and [NoneOfFilter]
abstract class CollectionDataEntity<T, S> extends DataEntity<T, S> {
  /// Creates a new DataEntity with [value]
  CollectionDataEntity([super.value]);
}

/// [DataEntity] representing [String] Objects
class StringDataEntity extends DataEntity<String, String> {
  /// Creates a new StringDataEntity Object with value [value]
  StringDataEntity([super.value]);

  @override
  String? get schemaValue => value;
}

/// [DataEntity] representing [DateTime] Objects
class DateTimeDataEntity extends ComparableDataEntity<DateTime, String> {
  /// Creates a new DateTimeDataEntity Object with value [value]
  DateTimeDataEntity([super.value]);

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
class DateDataEntity extends ComparableDataEntity<DateTime, String> {
  /// Creates a new DateTimeDataEntity Object with value [value]
  DateDataEntity([super.value]);

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
  BooleanDataEntity([bool? value]) : super(value ?? false);

  @override
  bool? get schemaValue => value;
}

/// [DataEntity] representing [int] Objects
class IntegerDataEntity extends ComparableDataEntity<int, int> {
  /// Creates a new IntegerDataEntity Object
  IntegerDataEntity([super.value]);

  @override
  int? get schemaValue => value;
}

/// [DataEntity] representing [double] Objects
class DecimalDataEntity extends ComparableDataEntity<double, double> {
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
class EnumCollectionDataEntity
    extends CollectionDataEntity<Set<String>, List<String>> {
  /// Creates a new EnumDataEntity Object with [value] out of possible [options]
  EnumCollectionDataEntity._({
    required Set<String> value,
    this.options = const {},
  }) : super(value);

  /// Creates a new EnumDataEntity Object with [value] out of possible [options]
  factory EnumCollectionDataEntity({
    Set<String>? value,
    Set<String> options = const {},
  }) {
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
        entityUri:
            jsonValue?['uri'] != null ? Uri.parse(jsonValue?['uri']) : null,
        gridUri: Uri.parse(gridUri),
      );

  /// The [Uri] pointing to the Entity this is referencing
  Uri? entityUri;

  /// Pointing to the [Grid] this is referencing
  final Uri gridUri;

  @override
  dynamic get schemaValue {
    if (entityUri == null) {
      return null;
    } else {
      return {'displayValue': value ?? '', 'uri': entityUri!.toString()};
    }
  }

  @override
  String toString() {
    return 'CrossReferenceDataEntity(displayValue: $value, entityUri: $entityUri, gridUri: $gridUri)';
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
class AttachmentDataEntity
    extends CollectionDataEntity<List<Attachment>, dynamic> {
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

/// [DataEntity] representing [Geolocation]s
class GeolocationDataEntity extends DataEntity<Geolocation, dynamic> {
  /// Creates a new GeolocationDataEntity Object with value [value]
  GeolocationDataEntity([super.value]);

  /// Creates a new GeolocationDataEntity Object from json
  /// [json] needs to be an array of double
  factory GeolocationDataEntity.fromJson(dynamic json) {
    Geolocation? jsonValue;
    if (json != null) {
      jsonValue = Geolocation.fromJson(json);
    }
    return GeolocationDataEntity(jsonValue);
  }

  /// Returns [value] coordinates in a array
  @override
  dynamic get schemaValue => value?.toJson();
}

/// [DataEntity] representing a list of objects CrossReferencing to a different Grid
class MultiCrossReferenceDataEntity
    extends CollectionDataEntity<List<CrossReferenceDataEntity>, dynamic> {
  /// Create a new CrossReference Data Entity
  MultiCrossReferenceDataEntity({
    List<CrossReferenceDataEntity>? references,
    required this.gridUri,
  }) : super(references ?? []);

  /// Creates a new MultiCrossReferenceDataEntity from a Json Response
  factory MultiCrossReferenceDataEntity.fromJson({
    required List? jsonValue,
    required String gridUri,
  }) {
    return MultiCrossReferenceDataEntity(
      references: jsonValue
              ?.map(
                (e) => CrossReferenceDataEntity.fromJson(
                  jsonValue: e,
                  gridUri: gridUri,
                ),
              )
              .toList() ??
          [],
      gridUri: Uri.parse(gridUri),
    );
  }

  /// Pointing to the [Grid] this is referencing
  final Uri gridUri;

  @override
  dynamic get schemaValue {
    if (value == null || value!.isEmpty) {
      return null;
    } else {
      return value!
          .map((crossReference) => crossReference.schemaValue)
          .toList();
    }
  }

  @override
  String toString() {
    return 'MultiCrossReferenceDataEntity(references: $value, gridUri: $gridUri)';
  }

  @override
  bool operator ==(Object other) {
    return other is MultiCrossReferenceDataEntity &&
        f.listEquals(value, other.value) &&
        gridUri == other.gridUri;
  }

  @override
  int get hashCode => toString().hashCode;
}

/// [DataEntity] representing [UserReference]s
class UserReferenceDataEntity extends DataEntity<UserReference, dynamic> {
  /// Creates a new UserReferenceDataEntity Object with value [value]
  UserReferenceDataEntity([super.value]);

  /// Creates a new UserReferenceDataEntity Object from json
  /// [json] needs to be an object that is parsed with [UserReference.fromJson]
  factory UserReferenceDataEntity.fromJson(dynamic json) {
    UserReference? jsonValue;
    if (json != null) {
      jsonValue = UserReference.fromJson(json);
    }
    return UserReferenceDataEntity(jsonValue);
  }

  /// Returns [value] as a json object map
  @override
  dynamic get schemaValue => value?.toJson();
}
