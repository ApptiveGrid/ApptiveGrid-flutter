import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/foundation.dart' as f;

/// Model representing a Field in a Grid
class GridField {
  /// Creates a GridField
  /// If [type] is [DataType.currency] use [CurrencyGridField] instead
  const GridField({
    required this.id,
    this.key,
    required this.name,
    required this.type,
    this.links = const {},
    this.schema,
  });

  /// Creates a GridField from [json]
  factory GridField.fromJson(Map<String, dynamic> json) {
    final type = DataType.values
        .firstWhere((type) => type.backendName == json['type']['name']);
    final id = json['id'];
    final name = json['name'];
    final key = json['key'];
    final links = linkMapFromJson(json['_links']);
    final schema = json['schema'];
    if (type == DataType.currency) {
      return CurrencyGridField(
        id: id,
        name: name,
        key: key,
        schema: schema,
        links: links,
        currency: json['type']['currency'],
      );
    }
    if (type == DataType.lookUp) {
      return LookUpGridField(
        id: id,
        name: name,
        key: key,
        schema: schema,
        links: links,
        referenceField: Uri.parse(json['type']['referenceField']),
        lookUpField: Uri.parse(json['type']['lookupField']),
        lookedUpField: GridField.fromJson({
          'id': 'lookedUpId',
          'name': 'lookedUp',
          'schema': {},
          'type': json['type']['lookupType'],
        }),
      );
    }
    if (type == DataType.reducedLookUp) {
      return ReducedLookUpField(
        id: id,
        name: name,
        key: key,
        schema: schema,
        links: links,
        referencesField: Uri.parse(json['type']['referencesField']),
        lookUpField: Uri.parse(json['type']['lookupField']),
        reduceFunction: json['type']['reduceFunction'],
        reducedField: GridField.fromJson({
          'id': 'reducedId',
          'name': 'reduced',
          'schema': {},
          'type': json['type']['reducedType'],
        }),
      );
    }
    if (type == DataType.formula) {
      return FormulaField(
        id: id,
        name: name,
        key: key,
        schema: schema,
        links: links,
        expression: json['type']['expression'],
        valueType: ValueType.fromJson(json['type']['valueType']),
      );
    }
    return GridField(
      id: id,
      name: name,
      key: key,
      schema: schema,
      links: links,
      type: type,
    );
  }

  /// id of the field
  final String id;

  /// A key associated with this field
  final String? key;

  /// name of the field
  final String name;

  /// type of the field
  final DataType type;

  /// Links that are associated with this GridField
  final LinkMap links;

  /// json Schema of this GridField
  final dynamic schema;

  @override
  String toString() {
    return 'GridField(id: $id, name: $name, type: $type)';
  }

  /// Converts this GridField to a json representation
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (key != null) 'key': key,
        if (schema != null) 'schema': schema,
        '_links': links.toJson(),
        'type': {'name': type.backendName},
      };

  @override
  bool operator ==(Object other) {
    return other is GridField &&
        id == other.id &&
        name == other.name &&
        key == other.key &&
        type == other.type &&
        f.mapEquals(links, other.links);
  }

  @override
  int get hashCode => Object.hash(id, name, key, type, links);
}

/// A [GridField] for [DataType.currency]
class CurrencyGridField extends GridField {
  /// Creates a new [GridField] for [DataType.currency] with [currency]
  const CurrencyGridField({
    required super.id,
    super.key,
    required super.name,
    super.links = const {},
    super.schema,
    required this.currency,
  }) : super(
          type: DataType.currency,
        );

  /// The ISO-4217 currency code for this field
  final String currency;

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['type'] = {
      ...json['type'],
      'currency': currency,
    };
    return json;
  }

  @override
  String toString() =>
      'CurrencyGridField(id: $id, name: $name, key: $key, currency: $currency)';

  @override
  bool operator ==(Object other) {
    return other is CurrencyGridField &&
        currency == other.currency &&
        id == other.id &&
        name == other.name &&
        f.mapEquals(links, other.links);
  }

  @override
  int get hashCode => Object.hash(
        GridField(
          id: id,
          name: name,
          type: type,
          key: key,
          links: links,
          schema: schema,
        ),
        currency,
      );
}

/// A [GridField] for [DataType.lookUp]
class LookUpGridField extends GridField {
  /// Creates a new [GridField] for [DataType.lookUp]
  const LookUpGridField({
    required super.id,
    super.key,
    required super.name,
    super.links = const {},
    super.schema,
    required this.referenceField,
    required this.lookUpField,
    required this.lookedUpField,
  }) : super(
          type: DataType.lookUp,
        );

  /// An uri pointing to the field that is used to look up
  final Uri referenceField;

  /// The field that is looked up
  final Uri lookUpField;

  /// A rough version of the lookedUp Field. This is not necessarily the full field
  final GridField lookedUpField;

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['type'] = {
      ...json['type'],
      'referenceField': referenceField.toString(),
      'lookupField': lookUpField.toString(),
      'lookupType': lookedUpField.toJson()['type'],
    };
    return json;
  }

  @override
  String toString() =>
      'LookUpGridField(id: $id, name: $name, key: $key, referenceField: ${referenceField.toString()}, lookupField: ${lookUpField.toString()}, lookupType: ${lookedUpField.type.name})';

  @override
  bool operator ==(Object other) {
    return other is LookUpGridField &&
        referenceField == other.referenceField &&
        lookUpField == other.lookUpField &&
        lookedUpField == other.lookedUpField &&
        id == other.id &&
        name == other.name &&
        f.mapEquals(links, other.links);
  }

  @override
  int get hashCode => Object.hash(
        GridField(
          id: id,
          name: name,
          type: type,
          key: key,
          links: links,
          schema: schema,
        ),
        referenceField,
        lookUpField,
        lookedUpField,
      );
}

/// A [GridField] for [DataType.reducedLookUp]
class ReducedLookUpField extends GridField {
  /// Creates a new [GridField] for [DataType.reducedLookUp]
  const ReducedLookUpField({
    required super.id,
    super.key,
    required super.name,
    super.links = const {},
    super.schema,
    required this.referencesField,
    required this.lookUpField,
    required this.reducedField,
    required this.reduceFunction,
  }) : super(
          type: DataType.reducedLookUp,
        );

  /// An uri pointing to the field that is used to look up
  final Uri referencesField;

  /// The field that is looked up
  final Uri lookUpField;

  /// A rough version of the reduced Field. This is not necessarily the full field
  final GridField reducedField;

  /// The function that is used to reduce the fields. E.g `sum` for summing numeric values
  final String reduceFunction;

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['type'] = {
      ...json['type'],
      'referencesField': referencesField.toString(),
      'lookupField': lookUpField.toString(),
      'reducedType': reducedField.toJson()['type'],
      'reduceFunction': reduceFunction,
    };
    return json;
  }

  @override
  String toString() =>
      'ReducedLookUpGridField(id: $id, name: $name, key: $key, referencesField: ${referencesField.toString()}, lookUpField: ${lookUpField.toString()}, reducedType: ${reducedField.type.name}, reduceFunction: $reduceFunction)';

  @override
  bool operator ==(Object other) {
    return other is ReducedLookUpField &&
        referencesField == other.referencesField &&
        lookUpField == other.lookUpField &&
        reducedField == other.reducedField &&
        id == other.id &&
        name == other.name &&
        reduceFunction == other.reduceFunction &&
        f.mapEquals(links, other.links);
  }

  @override
  int get hashCode => Object.hash(
        GridField(
          id: id,
          name: name,
          type: type,
          key: key,
          links: links,
          schema: schema,
        ),
        referencesField,
        lookUpField,
        reducedField,
        reduceFunction,
      );
}

/// A [GridField] for [DataType.formula]
class FormulaField extends GridField {
  /// Creates a new [GridField] for [DataType.formula]
  const FormulaField({
    required super.id,
    super.key,
    required super.name,
    super.links = const {},
    super.schema,
    required this.expression,
    required this.valueType,
  }) : super(
          type: DataType.formula,
        );

  /// A string representation of the formula
  final String expression;

  /// The result type of the formula
  final ValueType valueType;

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['type'] = {
      ...json['type'],
      'expression': expression,
      'valueType': valueType.toJson(),
    };
    return json;
  }

  @override
  String toString() =>
      'FormulaField(id: $id, name: $name, key: $key, expression: $expression, valueType: $valueType)';

  @override
  bool operator ==(Object other) {
    return other is FormulaField &&
        id == other.id &&
        name == other.name &&
        valueType == other.valueType &&
        expression == other.expression &&
        f.mapEquals(links, other.links);
  }

  @override
  int get hashCode => Object.hash(
        GridField(
          id: id,
          name: name,
          type: type,
          key: key,
          links: links,
          schema: schema,
        ),
        expression,
        valueType,
      );
}

/// The result type of the formula
class ValueType {
  /// Creates a new [ValueType]
  const ValueType({
    required this.type,
    this.additionalProperties,
  });

  /// Creates a [ValueType] from [json]
  factory ValueType.fromJson(Map<String, dynamic> json) {
    return ValueType(
      type: DataType.values.firstWhere(
        (type) => type.backendName == json['name'],
      ),
      additionalProperties: Map.fromEntries(
        json.entries.where((element) => element.key != 'name'),
      ),
    );
  }

  /// The result data type of the formula
  final DataType type;

  /// Additional information of the resulting field
  final Map<String, dynamic>? additionalProperties;

  /// Creates a [json] representation of the [ValueType]
  Map<String, dynamic> toJson() => {
        'name': type.backendName,
        ...additionalProperties ?? {},
      };

  @override
  String toString() =>
      'ValueType(type: ${type.backendName}, additionalProperties: $additionalProperties)';

  @override
  bool operator ==(Object other) {
    return other is ValueType &&
        type == other.type &&
        f.mapEquals(additionalProperties, other.additionalProperties);
  }

  @override
  int get hashCode => Object.hash(
        type,
        additionalProperties,
      );
}
