import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_core/cache/apptive_grid_cache.dart';
import 'package:apptive_grid_core/network/authentication/authentication_storage.dart';
import 'package:apptive_grid_core/network/authentication/io_authenticator.dart'
    if (dart.library.html) 'package:apptive_grid_core/network/web_authenticator.dart';

import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:openid_client/openid_client.dart' as openid;
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:uni_links_platform_interface/uni_links_platform_interface.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';

class MockHttpClient extends Mock implements Client {}

class MockApptiveGridClient extends Mock implements ApptiveGridClient {}

class MockApptiveGridAuthenticator extends Mock
    implements ApptiveGridAuthenticator {}

class MockCredential extends Mock implements openid.Credential {}

class MockToken extends Mock implements openid.TokenResponse {}

class MockAuthClient extends Mock implements openid.Client {}

class MockAuthenticator extends Mock implements Authenticator {}

class MockUniLinks extends Mock
    with MockPlatformInterfaceMixin
    implements UniLinksPlatform {}

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class MockApptiveGridCache extends Mock implements ApptiveGridCache {}

class MockAuthenticationStorage extends Mock implements AuthenticationStorage {}

class MockSecureStorage extends Mock with MockPlatformInterfaceMixin implements FlutterSecureStoragePlatform {}
