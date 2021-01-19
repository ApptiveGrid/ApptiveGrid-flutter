part of active_grid_model;

/// The Data Types that are available in Active Grid
enum DataType {
  /// Tyype to display [String]
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