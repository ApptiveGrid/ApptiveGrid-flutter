import 'package:active_grid_core/active_grid_core.dart';
import 'package:active_grid_core/network/active_grid_authenticator.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:openid_client/openid_client.dart' as openid;

class MockHttpClient extends Mock implements Client {}

class MockActiveGridClient extends Mock implements ActiveGridClient {}

class MockActiveGridAuthenticator extends Mock implements ActiveGridAuthenticator {}

class MockCredential extends Mock implements openid.Credential {}
