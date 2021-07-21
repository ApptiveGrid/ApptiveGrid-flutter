part of apptive_grid_network;

/// Model for authentication options
class ApptiveGridAuthenticationOptions {
  /// Creates Authentication Object
  /// [autoAuthenticate] determines if the auth process is started automatically. Defaults to false
  const ApptiveGridAuthenticationOptions({
    this.autoAuthenticate = false,
    this.redirectScheme,
  });

  /// Determines whether or not the authentication process should be started automatically or not
  final bool autoAuthenticate;

  /// If the Authentication is happening in an external Browser add your custom Redirect URI Scheme so the User gets redirected to the App
  ///
  /// Remember that you might need to add some native configurations so your app knows how to handle the redirect.
  /// For more Info check out https://pub.dev/packages/uni_links
  final String? redirectScheme;
}
