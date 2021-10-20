import 'dart:async';

/// Providing an interface to store User Credentials across sessions
abstract class AuthenticationStorage {
  /// Saves [credential]
  /// You should not change [credential]
  /// If [credential] is `null` it means the credential is invalid and should be deleted
  FutureOr<void> saveCredential(String? credential);

  /// Called to return the credential
  /// This should return an unmodified version of the credential received via `saveCredential`
  FutureOr<String?> get credential;
}
