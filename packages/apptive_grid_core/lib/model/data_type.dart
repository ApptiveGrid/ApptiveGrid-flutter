part of apptive_grid_model;

/// The Data Types that are available in ApptiveGrid
enum DataType {
  /// Type to display [String]
  text,

  /// Type to display [DateTime]
  dateTime,

  /// Type to display [DateTime] without the option to adjust the Time part
  date,

  /// Type to display [int] numbers
  integer,

  /// Type to display [double] decimal numbers
  decimal,

  /// Type to display [bool] values
  checkbox,

  /// Type to display enum values
  singleSelect,

  /// Select Multiple Values from List of possible Values
  enumCollection,

  /// Type to display CrossReference Values
  crossReference,

  /// Type for Attachments
  attachment,

  /// Type for geolocations
  geolocation,
}

/// Returns [DataType] that matching a certain schema [schemaProperty]
///
/// throws [ArgumentError] if DataType is not supported yet
DataType dataTypeFromSchemaProperty({
  required dynamic schemaProperty,
}) {
  final schemaType = schemaProperty['type'];
  final format = schemaProperty['format'];
  switch (schemaType) {
    case 'string':
      if (schemaProperty['enum'] != null) {
        return DataType.singleSelect;
      }
      switch (format) {
        case 'date-time':
          return DataType.dateTime;
        case 'date':
          return DataType.date;
      }
      return DataType.text;
    case 'integer':
      return DataType.integer;
    case 'number':
      return DataType.decimal;
    case 'boolean':
      return DataType.checkbox;
    case 'object':
      final objectType = schemaProperty['objectType'];
      switch (objectType) {
        case 'entityreference':
          return DataType.crossReference;
        case 'attachment':
          return DataType.attachment;
      }
      break;
    case 'array':
      if (schemaProperty['items'] is List &&
          f.setEquals((schemaProperty['items'].map<DataType>((item) =>
              dataTypeFromSchemaProperty(schemaProperty: item))
          as Iterable<DataType>)
              .toSet(), {DataType.decimal})) {
        return DataType.geolocation;
      }

      final itemType =
          dataTypeFromSchemaProperty(schemaProperty: schemaProperty['items']);
      switch (itemType) {
        case DataType.attachment:
          return DataType.attachment;
        case DataType.singleSelect:
          return DataType.enumCollection;
        case DataType.decimal:
          // TODO:  This will get a custom datatype in the future
          return DataType.geolocation;
        default:
          throw ArgumentError(
            'No defined Array type for type: $itemType',
          );
      }
  }
  throw ArgumentError(
    'No according DataType found for "$schemaType". Supported DataTypes are ${DataType.values}',
  );
}
