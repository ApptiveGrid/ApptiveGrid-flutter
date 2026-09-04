// Stub for dart:io on web platform — methods are never called on web.

import 'dart:typed_data';

/// Web stub for dart:io File.
class File {
  /// Creates a File stub with the given [path].
  File(this.path);

  /// The file path.
  final String path;

  /// Stub — returns empty bytes on web.
  ///
  /// Mirrors `dart:io`'s `Uint8List` return type: callers such as
  /// [AttachmentProcessor] declare `Future<Uint8List>`, and a `List<int>`
  /// here fails to compile for the web.
  Future<Uint8List> readAsBytes() async => Uint8List(0);

  /// Stub — returns false on web.
  Future<bool> exists() async => false;

  /// Stub — returns this on web.
  Future<File> create({bool recursive = false}) async => this;

  /// Stub — returns this on web.
  Future<File> writeAsBytes(List<int> bytes, {bool flush = false}) async =>
      this;
}

/// Web stub for dart:io Directory.
class Directory {
  /// Creates a Directory stub with the given [path].
  Directory(String path);

  /// Stub system temp directory.
  static final Directory systemTemp = Directory('');

  /// The directory path.
  String get path => '';
}
