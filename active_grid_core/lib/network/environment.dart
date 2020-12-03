part of active_grid_network;

enum ActiveGridEnvironment {
  alpha, beta, production
}

extension EnvironmentExtension on ActiveGridEnvironment {
  String get url {
    switch(this) {
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