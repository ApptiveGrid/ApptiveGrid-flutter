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
  ///
  /// defaults to the same url as [ActiveGridEnvironment.production]
  String get url {
    switch (this) {
      case ActiveGridEnvironment.alpha:
        return 'https://alpha.activegrid.de';
      case ActiveGridEnvironment.beta:
        return 'https://beta.activegrid.de';
      case ActiveGridEnvironment.production:
      default:
        return 'https://activegrid.de';
    }
  }
}
