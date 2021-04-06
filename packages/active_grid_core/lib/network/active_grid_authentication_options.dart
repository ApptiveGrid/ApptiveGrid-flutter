part of active_grid_network;

/// Model for authentication options
class ActiveGridAuthenticationOptions {
  /// Creates Authentication Object
  ActiveGridAuthenticationOptions({
    this.autoAuthenticate = false,
  });

  /// Determines whether or not the authentication process should be started automatically or not
  final bool autoAuthenticate;
}
