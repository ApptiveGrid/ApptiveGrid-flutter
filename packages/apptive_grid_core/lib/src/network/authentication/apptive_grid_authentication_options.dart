/// Model for authentication options
class ApptiveGridAuthenticationOptions {
  /// Creates Authentication Object
  /// [autoAuthenticate] determines if the auth process is started automatically. Defaults to false
  const ApptiveGridAuthenticationOptions({
    this.autoAuthenticate = false,
    this.redirectScheme,
    this.apiKey,
    this.persistCredentials = false,
    this.authGroup = 'apptivegrid',
  });

  /// Determines whether or not the authentication process should be started automatically or not
  final bool autoAuthenticate;

  /// If the Authentication is happening in an external Browser add your custom Redirect URI Scheme so the User gets redirected to the App
  ///
  /// Remember that you might need to add some native configurations so your app knows how to handle the redirect.
  /// For more Info check out https://pub.dev/packages/uni_links
  final String? redirectScheme;

  final String authGroup;

  /// [ApptiveGridApiKey] for authentication with an Api Key
  ///
  /// If this is not null it will be used instead of trying to authenticate using openid auth
  final ApptiveGridApiKey? apiKey;

  /// Determines whether or not credentials are saved across sessions.
  /// Internally this uses [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
  final bool persistCredentials;

  @override
  String toString() {
    return 'ApptiveGridAuthenticationOptions(autoAuthenticate: $autoAuthenticate, redirectScheme: $redirectScheme, apiKey: $apiKey, persistCredentials: $persistCredentials)';
  }

  @override
  bool operator ==(Object other) {
    return other is ApptiveGridAuthenticationOptions &&
        autoAuthenticate == other.autoAuthenticate &&
        redirectScheme == other.redirectScheme &&
        authGroup == other.authGroup &&
        apiKey == other.apiKey &&
        persistCredentials == other.persistCredentials;
  }

  @override
  int get hashCode => Object.hash(
        autoAuthenticate,
        redirectScheme,
        authGroup,
        apiKey,
        persistCredentials,
      );
}

/// Model to Handle Api Key Authentication
class ApptiveGridApiKey {
  /// Creates a ApptiveGridApiKey Model
  ///
  /// You will get these values if you create a new ApiKey in your Profile in the ApptiveGrid App
  const ApptiveGridApiKey({
    required this.authKey,
    required this.password,
  });

  /// Auth Key of the ApiKey
  final String authKey;

  /// Password of the ApiKey
  final String password;

  @override
  String toString() {
    return 'ApptiveGridApiKey(authKey: $authKey, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return other is ApptiveGridApiKey &&
        authKey == other.authKey &&
        password == other.password;
  }

  @override
  int get hashCode => Object.hash(authKey, password);
}
