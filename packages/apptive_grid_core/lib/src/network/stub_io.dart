// Stub for dart:io on web platform — methods are never called on web.

/// Web stub for dart:io File.
class File {
  /// Creates a File stub with the given [path].
  File(this.path);

  /// The file path.
  final String path;

  /// Stub — returns empty bytes on web.
  Future<List<int>> readAsBytes() async => [];

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
