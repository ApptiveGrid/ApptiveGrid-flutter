part of active_grid_network;

/// Model for authentication
class ActiveGridAuthentication {
  /// Creates Authentication Object
  ActiveGridAuthentication({required this.username, required this.password});

  /// Username
  final String username;

  /// Password
  final String password;

  /// Returns Header Value
  String get header {
    return 'Basic ${base64Url.encode(utf8.encode('$username:$password'))}';
  }
}
