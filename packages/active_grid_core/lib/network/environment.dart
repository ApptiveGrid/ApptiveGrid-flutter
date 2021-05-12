part of active_grid_network;

/// Possible Stages/Environment ActiveGrid can point to
enum ActiveGridEnvironment {
  /// Alpha Environment
  alpha,

  /// Beta Environment
  beta,

  /// Production Environment
  production
}

/// Extensions for [ActiveGridEnvironment]
extension EnvironmentExtension on ActiveGridEnvironment {
  /// Returns the API url for the selected [ActiveGridEnvironment]
  String get url {
    switch (this) {
      case ActiveGridEnvironment.alpha:
        return 'https://alpha.apptivegrid.de';
      case ActiveGridEnvironment.beta:
        return 'https://beta.apptivegrid.de';
      case ActiveGridEnvironment.production:
        return 'https://app.apptivegrid.de';
    }
  }

  /// Returns the realm that needs to be used for Authentication
  String get authRealm {
    switch (this) {
      case ActiveGridEnvironment.alpha:
      case ActiveGridEnvironment.beta:
        return 'apptivegrid-test';
      case ActiveGridEnvironment.production:
        return 'apptivegrid';
    }
  }
}
