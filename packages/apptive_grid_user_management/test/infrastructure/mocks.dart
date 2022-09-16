import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_core/src/network/authentication/apptive_grid_authenticator.dart';
import 'package:apptive_grid_user_management/src/user_management_client.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:uni_links_platform_interface/uni_links_platform_interface.dart';

class MockApptiveGridUserManagementClient extends Mock
    implements ApptiveGridUserManagementClient {}

class MockUniLinks extends Mock
    with MockPlatformInterfaceMixin
    implements UniLinksPlatform {}

class MockApptiveGridClient extends Mock implements ApptiveGridClient {}

class MockAuthenticator extends Mock implements ApptiveGridAuthenticator {}

class MockHttpClient extends Mock implements Client {}
