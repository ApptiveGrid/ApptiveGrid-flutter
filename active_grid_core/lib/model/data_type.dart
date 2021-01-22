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

/// Returns [DataType] that matching a certain schema [schemaProperty]
///
/// throws [ArgumentError] if DataType is not supported yet
DataType dataTypeFromSchemaProperty({dynamic schemaProperty}) {
  final schemaType = schemaProperty['type'];
  final format = schemaProperty['format'];
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
