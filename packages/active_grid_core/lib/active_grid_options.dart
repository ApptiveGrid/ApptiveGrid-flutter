import 'package:active_grid_core/active_grid_network.dart';

/// Configuration options for [ApptiveGrid]
class ApptiveGridOptions {
  /// Creates a configuration
  const ApptiveGridOptions({
    this.environment = ApptiveGridEnvironment.production,
    this.authenticationOptions,
  });

  /// Determines the API endpoint used
  final ApptiveGridEnvironment environment;

  /// Authentication for API
  final ApptiveGridAuthenticationOptions? authenticationOptions;
}
