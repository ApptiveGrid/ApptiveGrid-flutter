import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:http/http.dart' as http;

class ApptiveGridUserManagementClient {
  ApptiveGridUserManagementClient({
    required this.group,
    required this.clientId,
    this.redirectSchema,
    required this.apptiveGridClient,
    this.locale,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String group;
  final String clientId;
  final String? redirectSchema;

  final ApptiveGridClient apptiveGridClient;
  final String? locale;

  final http.Client _client;

  String? _email;
  String? _password;

  Map<String, String> get _commonHeaders => {
        'Content-Type': 'application/json',
        if (locale != null) 'Accept-Language': locale!
      };

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
        if (redirectSchema != null) 'redirectSchema': redirectSchema,
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

  Future<http.Response> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.get(
      Uri.parse(
        '${apptiveGridClient.options.environment.url}/auth/login?clientId=$clientId',
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

  Future<http.Response> confirmAccount({required Uri confirmationUri}) async {
    final response = await _client.get(confirmationUri);

    if (response.statusCode >= 400) {
      throw response;
    } else {
      return response;
    }
  }
}
