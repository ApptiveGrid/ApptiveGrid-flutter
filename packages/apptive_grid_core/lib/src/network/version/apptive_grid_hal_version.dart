enum ApptiveGridHalVersion {
  v1(headerValue: 'application/vnd.apptivegrid.hal'),
  v2(headerValue: 'application/vnd.apptivegrid.hal;version=2');

  const ApptiveGridHalVersion({required this.headerValue});

  final String headerValue;

  MapEntry<String, String> get header => MapEntry('Accept', headerValue);
}
