part of apptive_grid_network;

/// Possible Stages/Environment ApptiveGrid can point to
enum ApptiveGridEnvironment {
  /// Alpha Environment
  alpha,

  /// Beta Environment
  beta,

  /// Production Environment
  production
}

/// Extensions for [ApptiveGridEnvironment]
extension EnvironmentExtension on ApptiveGridEnvironment {
  /// Returns the API url for the selected [ApptiveGridEnvironment]
  String get url {
    switch (this) {
      case ApptiveGridEnvironment.alpha:
        return 'https://alpha.apptivegrid.de';
      case ApptiveGridEnvironment.beta:
        return 'https://beta.apptivegrid.de';
      case ApptiveGridEnvironment.production:
        return 'https://app.apptivegrid.de';
    }
  }

  /// Returns the realm that needs to be used for Authentication
  String get authRealm {
    switch (this) {
      case ApptiveGridEnvironment.alpha:
      case ApptiveGridEnvironment.beta:
        return 'apptivegrid-test';
      case ApptiveGridEnvironment.production:
        return 'apptivegrid';
    }
  }
}
