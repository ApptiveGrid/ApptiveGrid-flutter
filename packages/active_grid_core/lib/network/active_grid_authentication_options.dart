part of active_grid_network;

/// Model for authentication options
class ApptiveGridAuthenticationOptions {
  /// Creates Authentication Object
  /// [autoAuthenticate] determines if the auth process is started automatically. Defaults to false
  ApptiveGridAuthenticationOptions({
    this.autoAuthenticate = false,
  });

  /// Determines whether or not the authentication process should be started automatically or not
  final bool autoAuthenticate;
}
