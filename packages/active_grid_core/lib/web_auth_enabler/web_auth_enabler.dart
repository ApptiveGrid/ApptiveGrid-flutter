import 'package:active_grid_core/web_auth_enabler/configure_nonweb.dart'
    if (dart.library.html) 'package:active_grid_core/web_auth_enabler/configure_web.dart'
    as implementation;

/// Enable Authentication on the Web
/// This is using a conditional import to listen for Authentication on the Web
Future<void> enableWebAuth() {
  return implementation.enableWebAuth();
}
