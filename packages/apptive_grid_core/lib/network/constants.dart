part of apptive_grid_network;

// ignore_for_file: public_member_api_docs

/// HttpHeaders Used in ApptiveGrid Requests
/// These are normally part of dart:io which would limit the functionality for the web
abstract class HttpHeaders {
  static const authorizationHeader = 'authorization';
  static const contentTypeHeader = 'content-type';
}

/// ContentType Used in ApptiveGrid Requests
/// These are normally part of dart:io which would limit the functionality for the web
abstract class ContentType {
  static const json = 'application/json';
}
