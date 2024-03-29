import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:http/http.dart' as http;

/// A network client to perform requests to the ApptiveGridUserManagement Api
class ApptiveGridUserManagementClient {
  /// Creates a new client
  ApptiveGridUserManagementClient({
    required this.group,
    required this.clientId,
    this.redirectScheme,
    required this.apptiveGridClient,
    this.locale,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// User Group the users should be added to
  final String group;

  /// The Client Id
  final String clientId;

  /// The redirect Scheme that should be used in the Confirmation Link in the email
  /// if this is not provided the email will contain a https://app.apptivegrid.de/ link
  /// If you want to use the https Links (support for iOS Universal Linking) contact ApptiveGrid to get your App added
  /// info@apptivegrid.de
  final String? redirectScheme;

  /// ApptiveGridClient. This is used to save the token after login
  final ApptiveGridClient apptiveGridClient;

  /// Locale that should be used. This determines the language the email will be send in
  final String? locale;

  final http.Client _client;

  String? _email;
  String? _password;

  Map<String, String> get _commonHeaders => {
        'Content-Type': 'application/json',
        if (locale != null) 'Accept-Language': locale!,
      };

  /// Registers a new user with the given inputs
  Future<http.Response> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse(
        '${apptiveGridClient.options.environment.url}/auth/$group/users',
      ),
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        if (redirectScheme != null) 'redirectScheme': redirectScheme,
      }),
      headers: _commonHeaders,
    );

    if (response.statusCode >= 400) {
      throw response;
    } else {
      _email = email;
      _password = password;
      return response;
    }
  }

  /// Performs a login request with [email] and [password]
  /// If the login succeeds the token will be set in [apptiveGridClient]
  Future<http.Response> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.get(
      Uri.parse(
        '${apptiveGridClient.options.environment.url}/auth/$group/login?clientId=$clientId',
      ),
      headers: {
        ..._commonHeaders,
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$email:$password'))}',
      },
    );

    _email = null;
    _password = null;
    if (response.statusCode >= 400) {
      throw response;
    } else {
      await apptiveGridClient.setUserToken(jsonDecode(response.body));
      return response;
    }
  }

  /// Tries to log in the user after account confirmation.
  /// This will return if the login was successful or not
  /// It will only be successful if the user registered in the same session and thus the users email and password are stored in the client
  Future<bool> loginAfterConfirmation() async {
    if (_email == null || _password == null) {
      return false;
    } else {
      final loginResponse =
          await login(email: _email!, password: _password!).catchError((error) {
        return http.Response(
          error.toString(),
          error is http.Response ? error.statusCode : 400,
        );
      });
      return loginResponse.statusCode < 400;
    }
  }

  /// Performs a GET request against [confirmationUri] to confirm a user account
  Future<http.Response> confirmAccount({required Uri confirmationUri}) async {
    final response = await _client.get(confirmationUri);

    if (response.statusCode >= 400) {
      throw response;
    } else {
      return response;
    }
  }

  /// Performs a request that will try to send a Email with a link to reset the user's password to [email]
  ///
  /// If there is no user with the provided [email] it will behave as if there was to prevent collecting of addresses
  ///
  /// This will save [email] in the session to allow [loginAfterConfirmation] to succeed if the user also [resetPassword] in the same session
  Future<http.Response> requestResetPassword({required String email}) async {
    final response = await _client.post(
      Uri.parse(
        '${apptiveGridClient.options.environment.url}/auth/$group/forgotPassword',
      ),
      body: jsonEncode({
        'email': email,
        if (redirectScheme != null) 'redirectScheme': redirectScheme,
      }),
      headers: _commonHeaders,
    );

    if (response.statusCode >= 400) {
      if (response.statusCode == 404) {
        return http.Response('OK', 200);
      }
      throw response;
    } else {
      _email = email;
      return response;
    }
  }

  /// Resets the user's password to [newPassword] by calling PUT against [resetUri]
  ///
  /// This will save [newPassword] in the session to allow [loginAfterConfirmation] to succeed if the user also called [requestResetPassword] or [register] before
  Future<http.Response> resetPassword({
    required Uri resetUri,
    required String newPassword,
  }) async {
    final response = await _client.put(
      resetUri,
      body: jsonEncode(
        {
          'newPassword': newPassword,
        },
      ),
      headers: _commonHeaders,
    );

    if (response.statusCode >= 400) {
      throw response;
    } else {
      _password = newPassword;
      return response;
    }
  }

  /// Perform a call to delete the user's account
  /// This will return `true` if the account deletion was successful
  Future<bool> deleteAccount() async {
    final isAuthenticated = await apptiveGridClient.isAuthenticatedWithToken;

    if (!isAuthenticated) {
      return false;
    }
    await apptiveGridClient.authenticator.checkAuthentication();
    final deleteResponse = await _client.delete(
      Uri.parse(
        '${apptiveGridClient.options.environment.url}/auth/$group/users/me',
      ),
      headers: apptiveGridClient.defaultHeaders,
    );

    if (deleteResponse.statusCode >= 400) {
      throw deleteResponse;
    } else {
      return true;
    }
  }
}
