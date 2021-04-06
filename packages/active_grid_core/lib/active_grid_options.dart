import 'package:active_grid_core/active_grid_network.dart';

/// Configuration options for [ActiveGrid]
class ActiveGridOptions {
  /// Creates a configuration
  const ActiveGridOptions({
    this.environment = ActiveGridEnvironment.production,
    this.authenticationOptions,
  });

  /// Determines the API endpoint used
  final ActiveGridEnvironment environment;

  /// Authentication for API
  final ActiveGridAuthenticationOptions? authenticationOptions;
}
