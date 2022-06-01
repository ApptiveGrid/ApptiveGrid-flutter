import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_core/network/authentication/web_auth_enabler/configure_nonweb.dart'
    if (dart.library.html) 'package:apptive_grid_core/network/authentication/web_auth_enabler/configure_web.dart'
    as implementation;

/// Enable Authentication on the Web
/// This is using a conditional import to listen for Authentication on the Web
Future<void> enableWebAuth(ApptiveGridOptions options) {
  return implementation.enableWebAuth(options);
}
