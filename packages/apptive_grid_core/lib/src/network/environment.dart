/// Possible Stages/Environment ApptiveGrid can point to
enum ApptiveGridEnvironment {
  /// Alpha Environment
  alpha(url: 'https://alpha.apptivegrid.de'),

  /// Beta Environment
  beta(url: 'https://beta.apptivegrid.de'),

  /// Production Environment
  production(url: 'https://app.apptivegrid.de');

  /// Create a new ApptiveGridEnvironment
  const ApptiveGridEnvironment({required this.url});

  /// The API url for the selected [ApptiveGridEnvironment]
  final String url;
}
