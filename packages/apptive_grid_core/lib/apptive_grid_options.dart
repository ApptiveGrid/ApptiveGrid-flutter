import 'package:apptive_grid_core/apptive_grid_network.dart';
import 'package:apptive_grid_core/cache/apptive_grid_cache.dart';

/// Configuration options for [ApptiveGrid]
class ApptiveGridOptions {
  /// Creates a configuration
  const ApptiveGridOptions({
    this.environment = ApptiveGridEnvironment.production,
    this.authenticationOptions = const ApptiveGridAuthenticationOptions(),
    this.cache,
  });

  /// Determines the API endpoint used
  final ApptiveGridEnvironment environment;

  /// Authentication for API
  final ApptiveGridAuthenticationOptions authenticationOptions;

  /// Implementation for Caching. Use this to cache/store values for faster initial Data
  /// This can also be used to enable offline mode sending
  final ApptiveGridCache? cache;

  /// Creates a copy of [ApptiveGridOptions] with the provided values
  ApptiveGridOptions copyWith({
    ApptiveGridEnvironment? environment,
    ApptiveGridAuthenticationOptions? authenticationOptions,
    ApptiveGridCache? cache,
  }) {
    return ApptiveGridOptions(
      environment: environment ?? this.environment,
      authenticationOptions:
          authenticationOptions ?? this.authenticationOptions,
      cache: cache ?? this.cache,
    );
  }

  @override
  String toString() {
    return 'ApptiveGridOptions(environment: $environment, authenticationOptions: $authenticationOptions, cache: $cache)';
  }

  @override
  bool operator ==(Object other) {
    return other is ApptiveGridOptions &&
        other.environment == environment &&
        other.authenticationOptions == authenticationOptions &&
        other.cache == other.cache;
  }

  @override
  int get hashCode => toString().hashCode;
}
