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
