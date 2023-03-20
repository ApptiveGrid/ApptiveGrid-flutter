/// Enumeration of possible HalVersion to be used to enable specific features/formats of responses
enum ApptiveGridHalVersion {
  /// The first version of hal
  v1(headerValue: 'application/vnd.apptivegrid.hal'),

  /// Second Version adding functionality to calls/models that already have specific behaviour for [v1]
  v2(headerValue: 'application/vnd.apptivegrid.hal;version=2');

  /// Constructor for Enum with [halVersion]
  const ApptiveGridHalVersion({required this.headerValue});

  /// Value that should be send as an [Accept] Header in a request in order for the halVersion to take effect
  final String headerValue;

  /// A MapEntry to be used in a Header Map. Sets [headerValue] as the `Accept` value
  MapEntry<String, String> get header => MapEntry('Accept', headerValue);
}
