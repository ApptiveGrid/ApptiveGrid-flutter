import 'dart:async';

abstract class AuthenticationStorage {
  FutureOr<void> saveToken(String? token);
  FutureOr<String?> get token;
}