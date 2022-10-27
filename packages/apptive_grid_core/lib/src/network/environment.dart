/// Possible Stages/Environment ApptiveGrid can point to
enum ApptiveGridEnvironment {
  /// Alpha Environment
  alpha(url: 'http://alpha.apptivegrid.de'),

  /// Beta Environment
  beta(url: 'http://beta.apptivegrid.de'),

  /// Production Environment
  production(url: 'https://app.apptivegrid.de');

  /// Create a new ApptiveGridEnvironment
  const ApptiveGridEnvironment({required this.url});

  /// The API url for the selected [ApptiveGridEnvironment]
  final String url;
}
