// Stub for dart:io on web platform — methods are never called on web.

class File {
  File(String path) : path = path;
  final String path;
  Future<List<int>> readAsBytes() async => [];
  Future<bool> exists() async => false;
  Future<File> create({bool recursive = false}) async => this;
  Future<File> writeAsBytes(List<int> bytes, {bool flush = false}) async =>
      this;
}

class Directory {
  Directory(String path);
  static final Directory systemTemp = Directory('');
  String get path => '';
}
