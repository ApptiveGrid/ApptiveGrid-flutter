part of apptive_grid_model;

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
    } else {
      return GridField(
        id: id,
        name: name,
        key: key,
        schema: schema,
        links: links,
        type: type,
      );
    }
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
