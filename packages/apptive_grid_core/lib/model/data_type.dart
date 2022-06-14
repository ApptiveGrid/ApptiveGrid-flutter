part of apptive_grid_model;

/// The Data Types that are available in ApptiveGrid
enum DataType {
  /// Type to display [String]
  text(backendName: 'string'),

  /// Type to display [DateTime]
  dateTime(backendName: 'date-time'),

  /// Type to display [DateTime] without the option to adjust the Time part
  date(backendName: 'date'),

  /// Type to display [int] numbers
  integer(backendName: 'integer'),

  /// Type to display [double] decimal numbers
  decimal(backendName: 'decimal'),

  /// Type to display [bool] values
  checkbox(backendName: 'boolean'),

  /// Type to display enum values
  singleSelect(backendName: 'enum'),

  /// Select Multiple Values from List of possible Values
  enumCollection(backendName: 'enumcollection'),

  /// Type to display CrossReference Values
  crossReference(backendName: 'reference'),

  /// Type for Attachments
  attachment(backendName: 'attachments'),

  /// Type for geolocations
  geolocation(backendName: 'geolocation'),

  /// Type for Multi Cross References
  multiCrossReference(backendName: 'references'),

  /// Type for UserReferences. Used for createdBy
  @Deprecated('Use createdBy instead')
  userReference(backendName: 'createdby'),

  /// Type for UserReferences. Used for createdBy
  createdBy(backendName: 'createdby');

  /// Define a Datatype with a corresponding [backendName]
  const DataType({
    required this.backendName,
  });

  /// The name that is used in the ApptiveGridBackend for this [DataType]
  final String backendName;
}
