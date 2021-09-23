part of apptive_grid_model;

/// The Data Types that are available in Apptive grid
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
  selectionBox,

  /// Type to display CrossReference Values
  crossReference,
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
        return DataType.selectionBox;
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
      }
  }
  throw ArgumentError(
    'No according DataType found for "$schemaType". Supported DataTypes are ${DataType.values}',
  );
}
