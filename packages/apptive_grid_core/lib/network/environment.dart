part of apptive_grid_network;

/// Possible Stages/Environment ApptiveGrid can point to
enum ApptiveGridEnvironment {
  /// Alpha Environment
  alpha(url: 'https://alpha.apptivegrid.de', authRealm: 'apptivegrid-test'),

  /// Beta Environment
  beta(url: 'https://beta.apptivegrid.de', authRealm: 'apptivegrid-test'),

  /// Production Environment
  production(url: 'https://app.apptivegrid.de', authRealm: 'apptivegrid');

  /// Create a new ApptiveGridEnvironment
  const ApptiveGridEnvironment({required this.url, required this.authRealm});

  /// The API url for the selected [ApptiveGridEnvironment]
  final String url;

  ///The authentication realm that needs to be used for Authentication
  final String authRealm;
}
