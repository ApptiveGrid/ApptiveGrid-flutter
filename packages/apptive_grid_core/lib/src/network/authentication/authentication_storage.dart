import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

/// Implementation of [AuthenticationStorage] based on [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
class FlutterSecureStorageCredentialStorage implements AuthenticationStorage {
  /// Creates a new AuthenticationStorage
  const FlutterSecureStorageCredentialStorage();

  static const _credentialKey = 'ApptiveGridCredential';

  final _flutterSecureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  @override
  FutureOr<String?> get credential =>
      _flutterSecureStorage.read(key: _credentialKey);

  @override
  FutureOr<void> saveCredential(String? credential) {
    _flutterSecureStorage.write(key: _credentialKey, value: credential);
  }
}
