part of apptive_grid_model;

/// Model representing a DataEntry from ApptiveGrid
///
/// [T] type of the data used in Flutter
/// [S] type used when sending Data back
abstract class DataEntity<T, S> with FilterableMixin {
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
        value == other.value;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  dynamic get filterValue => schemaValue;

  /// Creates a new DataEntity from [json]
  /// [field] is used to determine the runtimeType of the [DataEntity] based on [GridField.type]
  static DataEntity fromJson({
    required dynamic json,
    required GridField field,
  }) {
    switch (field.type) {
      case DataType.text:
        return StringDataEntity(json);
      case DataType.dateTime:
        return DateTimeDataEntity.fromJson(json);
      case DataType.date:
        return DateDataEntity.fromJson(json);
      case DataType.integer:
        return IntegerDataEntity(json);
      case DataType.checkbox:
        return BooleanDataEntity(json);
      case DataType.singleSelect:
        return EnumDataEntity(
          value: json,
          options:
              (field.schema['enum'].cast<String>() as List<String>).toSet(),
        );
      case DataType.crossReference:
        return CrossReferenceDataEntity.fromJson(
          jsonValue: json,
          gridUri: field.schema['gridUri'],
        );
      case DataType.decimal:
        return DecimalDataEntity(json);
      case DataType.attachment:
        return AttachmentDataEntity.fromJson(json);
      case DataType.enumCollection:
        return EnumCollectionDataEntity(
          value: ((json ?? <String>[]).cast<String>() as List<String>).toSet(),
          options:
              (field.schema['items']['enum'].cast<String>() as List<String>)
                  .toSet(),
        );
      case DataType.geolocation:
        return GeolocationDataEntity.fromJson(json);
      case DataType.multiCrossReference:
        return MultiCrossReferenceDataEntity.fromJson(
          jsonValue: json,
          gridUri: field.schema['items']['gridUri'],
        );
      case DataType.createdBy:
        return CreatedByDataEntity.fromJson(json);
      case DataType.user:
        return UserDataEntity.fromJson(json);
      case DataType.currency:
        return CurrencyDataEntity(
          value: json,
          currency: (field as CurrencyGridField).currency,
        );
      case DataType.uri:
        return UriDataEntity.fromJson(json);
    }
  }
}

/// [DataEntity] representing [String] Objects
class StringDataEntity extends DataEntity<String, String> {
  /// Creates a new StringDataEntity Object with value [value]
  StringDataEntity([super.value]);

  @override
  String? get schemaValue => value;
}

/// [DataEntity] representing [DateTime] Objects
class DateTimeDataEntity extends DataEntity<DateTime, String>
    with ComparableFilterableMixin {
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
class DateDataEntity extends DataEntity<DateTime, String>
    with ComparableFilterableMixin {
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
class IntegerDataEntity extends DataEntity<int, int>
    with ComparableFilterableMixin {
  /// Creates a new IntegerDataEntity Object
  IntegerDataEntity([super.value]);

  @override
  int? get schemaValue => value;
}

/// [DataEntity] representing [double] Objects
class DecimalDataEntity extends DataEntity<double, double>
    with ComparableFilterableMixin {
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
        value == other.value &&
        f.setEquals(options, other.options);
  }

  @override
  int get hashCode => toString().hashCode;
}

/// [DataEntity] representing an enum like Object
class EnumCollectionDataEntity extends DataEntity<Set<String>, List<String>>
    with CollectionFilterableMixin {
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
class AttachmentDataEntity extends DataEntity<List<Attachment>, dynamic>
    with CollectionFilterableMixin {
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
    extends DataEntity<List<CrossReferenceDataEntity>, dynamic>
    with CollectionFilterableMixin {
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

/// [DataEntity] representing [CreatedBy]s
class CreatedByDataEntity extends DataEntity<CreatedBy, dynamic> {
  /// Creates a new UserReferenceDataEntity Object with value [value]
  CreatedByDataEntity([super.value]);

  /// Creates a new UserReferenceDataEntity Object from json
  /// [json] needs to be an object that is parsed with [CreatedBy.fromJson]
  factory CreatedByDataEntity.fromJson(dynamic json) {
    CreatedBy? jsonValue;
    if (json != null) {
      jsonValue = CreatedBy.fromJson(json);
    }
    return CreatedByDataEntity(jsonValue);
  }

  /// Returns [value] as a json object map
  @override
  dynamic get schemaValue => value?.toJson();
}

/// [DataEntity] representing a [DataUser]
class UserDataEntity extends DataEntity<DataUser, dynamic> {
  /// Creates a new UserDataEntity Object with value [value]
  UserDataEntity([super.value]);

  /// Creates a new UserDataEntity Object from json
  /// [json] needs to be an object that is parsed with [DataUser.fromJson]
  factory UserDataEntity.fromJson(dynamic json) {
    DataUser? jsonUser;
    if (json != null) {
      jsonUser = DataUser.fromJson(json);
    }
    return UserDataEntity(jsonUser);
  }

  /// Returns [value] as a json object map
  @override
  dynamic get schemaValue => value?.toJson();
}

/// [DataEntity] to display a currency
class CurrencyDataEntity extends DataEntity<double, double> {
  /// Creates a new CurrencyDataEntity to have a amount of [value] in a specific [currency]
  CurrencyDataEntity({num? value, required this.currency})
      : super(value?.toDouble());

  @override
  double? get schemaValue => value;

  /// ISO4217 currency code of this [value]
  final String currency;

  @override
  String toString() => 'CurrencyDataEntity($value, currency: $currency)';

  @override
  bool operator ==(Object other) {
    return other is CurrencyDataEntity &&
        value == other.value &&
        currency == other.currency;
  }

  @override
  int get hashCode => super.hashCode + currency.hashCode;
}

/// [DataEntity] to representing a [Uri]
class UriDataEntity extends DataEntity<Uri, String> {
  /// Creates a new UriDataEntity to have a [value]
  UriDataEntity([super.value]);

  /// Creates a new UriDataEntity to have a [value]
  factory UriDataEntity.fromJson(String? json) =>
      UriDataEntity(json != null ? Uri.tryParse(json) : null);

  /// Returns [value] as a json object map
  @override
  String? get schemaValue => value?.toString();
}
