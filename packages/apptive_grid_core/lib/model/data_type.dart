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

  /// Type for CreatedBy.
  createdBy(backendName: 'createdby'),

  /// Type for User. A use case might be to assign a task to a user
  user(backendName: 'user'),

  /// Type for Currency
  currency(backendName: 'currency'),

  /// Type for Uris
  uri(backendName: 'uri');

  /// Define a Datatype with a corresponding [backendName]
  const DataType({
    required this.backendName,
  });

  /// The name that is used in the ApptiveGridBackend for this [DataType]
  final String backendName;

  /// Deprecated Type for UserReferences. Used for createdBy
  @Deprecated('Use createdBy instead')
  static const DataType userReference = DataType.createdBy;
}
