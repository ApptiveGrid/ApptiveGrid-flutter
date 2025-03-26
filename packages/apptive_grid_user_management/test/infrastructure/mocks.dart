import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_core/src/network/authentication/apptive_grid_authenticator.dart';
import 'package:apptive_grid_user_management/src/user_management_client.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_links/app_links.dart';

class MockApptiveGridUserManagementClient extends Mock
    implements ApptiveGridUserManagementClient {}

class MockAppLinks extends Mock implements AppLinks {}

class MockApptiveGridClient extends Mock implements ApptiveGridClient {}

class MockAuthenticator extends Mock implements ApptiveGridAuthenticator {}

class MockHttpClient extends Mock implements Client {}
