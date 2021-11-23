import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:apptive_grid_core/apptive_grid_network.dart';
import 'package:apptive_grid_core/cache/apptive_grid_cache.dart';
import 'package:flutter/foundation.dart';

/// Configuration options for [ApptiveGrid]
class ApptiveGridOptions {
  /// Creates a configuration
  const ApptiveGridOptions({
    this.environment = ApptiveGridEnvironment.production,
    this.authenticationOptions = const ApptiveGridAuthenticationOptions(),
    this.cache,
    this.attachmentConfigurations = const {},
  });

  /// Determines the API endpoint used
  final ApptiveGridEnvironment environment;

  /// Authentication for API
  final ApptiveGridAuthenticationOptions authenticationOptions;

  /// Implementation for Caching. Use this to cache/store values for faster initial Data
  /// This can also be used to enable offline mode sending
  final ApptiveGridCache? cache;

  /// Configurations for Attachments
  ///
  /// this can be specified directly or properly you want to use the Helper Function
  /// [attachmentConfigurationMapFromConfigString] which takes in your configuration
  final Map<ApptiveGridEnvironment, AttachmentConfiguration?>
      attachmentConfigurations;

  /// Creates a copy of [ApptiveGridOptions] with the provided values
  ApptiveGridOptions copyWith({
    ApptiveGridEnvironment? environment,
    ApptiveGridAuthenticationOptions? authenticationOptions,
    ApptiveGridCache? cache,
    Map<ApptiveGridEnvironment, AttachmentConfiguration>?
        attachmentConfigurations,
  }) {
    return ApptiveGridOptions(
      environment: environment ?? this.environment,
      authenticationOptions:
          authenticationOptions ?? this.authenticationOptions,
      cache: cache ?? this.cache,
      attachmentConfigurations:
          attachmentConfigurations ?? this.attachmentConfigurations,
    );
  }

  @override
  String toString() {
    return 'ApptiveGridOptions(environment: $environment, authenticationOptions: $authenticationOptions, cache: $cache, attachmentConfigurations: $attachmentConfigurations)';
  }

  @override
  bool operator ==(Object other) {
    return other is ApptiveGridOptions &&
        other.environment == environment &&
        other.authenticationOptions == authenticationOptions &&
        other.cache == other.cache &&
        mapEquals(other.attachmentConfigurations, attachmentConfigurations);
  }

  @override
  int get hashCode => toString().hashCode;
}
