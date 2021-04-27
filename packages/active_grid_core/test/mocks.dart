import 'package:active_grid_core/active_grid_core.dart';
import 'package:active_grid_core/network/io_authenticator.dart'
  if (dart.library.html) 'package:active_grid_core/network/web_authenticator.dart';

import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:openid_client/openid_client.dart' as openid;
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHttpClient extends Mock implements Client {}

class MockActiveGridClient extends Mock implements ActiveGridClient {}

class MockActiveGridAuthenticator extends Mock
    implements ActiveGridAuthenticator {}

class MockCredential extends Mock implements openid.Credential {}

class MockToken extends Mock implements openid.TokenResponse {}

class MockAuthClient extends Mock implements openid.Client {}

class MockAuthenticator extends Mock implements Authenticator {}

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}
