part of apptive_grid_network;

/// Model for authentication options
class ApptiveGridAuthenticationOptions {
  /// Creates Authentication Object
  /// [autoAuthenticate] determines if the auth process is started automatically. Defaults to false
  const ApptiveGridAuthenticationOptions({
    this.autoAuthenticate = false,
    this.redirectScheme,
    this.apiKey,
  });

  /// Determines whether or not the authentication process should be started automatically or not
  final bool autoAuthenticate;

  /// If the Authentication is happening in an external Browser add your custom Redirect URI Scheme so the User gets redirected to the App
  ///
  /// Remember that you might need to add some native configurations so your app knows how to handle the redirect.
  /// For more Info check out https://pub.dev/packages/uni_links
  final String? redirectScheme;

  /// [ApptiveGridApiKey] for authentication with an Api Key
  ///
  /// If this is not null it will be used instead of trying to authenticate using openid auth
  final ApptiveGridApiKey? apiKey;

  @override
  String toString() {
    return 'ApptiveGridAuthenticationOptions(autoAuthenticate: $autoAuthenticate, redirectScheme: $redirectScheme, apiKey: $apiKey)';
  }

  @override
  bool operator ==(Object other) {
    return other is ApptiveGridAuthenticationOptions &&
        autoAuthenticate == other.autoAuthenticate &&
        redirectScheme == other.redirectScheme &&
        apiKey == other.apiKey;
  }

  @override
  int get hashCode => toString().hashCode;
}

/// Model to Handle Api Key Authentication
class ApptiveGridApiKey {
  /// Creates a ApptiveGridApiKey Model
  ///
  /// You will get these values if you create a new ApiKey in your Profile in the ApptiveGrid App
  const ApptiveGridApiKey({required this.authKey, required this.password});

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
  int get hashCode => toString().hashCode;
}
