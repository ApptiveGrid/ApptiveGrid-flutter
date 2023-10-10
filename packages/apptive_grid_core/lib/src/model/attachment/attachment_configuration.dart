import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_core.dart';

/// Configuration for ApiEndpoints to support Attachments
///
/// More Info on how to optain these configurations will be provided later
class AttachmentConfiguration {
  /// Creates a new AttachmentConfiguration
  const AttachmentConfiguration({
    required this.signedUrlApiEndpoint,
    required this.attachmentApiEndpoint,
    this.signedUrlFormApiEndpoint,
  });

  /// Creates a new AttachmentConfiguration from json
  factory AttachmentConfiguration.fromJson(Map<String, dynamic> json) =>
      switch (json) {
        {
          'signedUrlEndpoint': String? signedUrlEndpoint,
          'signedUrl': String signedUrl,
          'unauthenticatedSignedUrlEndpoint': String?
              unauthenticatedSignedUrlEndpoint,
          'signedUrlForm': String signedUrlForm,
          'apiEndpoint': String? apiEndpoint,
          'storageUrl': String storageUrl,
        } =>
          AttachmentConfiguration(
            signedUrlApiEndpoint: signedUrlEndpoint ?? signedUrl,
            signedUrlFormApiEndpoint:
                unauthenticatedSignedUrlEndpoint ?? signedUrlForm,
            attachmentApiEndpoint: apiEndpoint ?? storageUrl,
          ),
        _ => throw ArgumentError.value(
            json,
            'Invalid AttachmentConfiguration json: $json',
          ),
      };

  /// Endpoint used to generate an upload url
  final String signedUrlApiEndpoint;

  /// Endpoint used to generate an upload url for forms
  /// this endpoint should work without authentication
  final String? signedUrlFormApiEndpoint;

  /// Endpoint to store data at
  final String attachmentApiEndpoint;

  @override
  String toString() {
    return 'AttachmentConfiguration(signedUrlApiEndpoint: $signedUrlApiEndpoint, signedUrlFormApiEndpoint: $signedUrlFormApiEndpoint, attachmentApiEndpoint: $attachmentApiEndpoint)';
  }

  @override
  bool operator ==(Object other) {
    return other is AttachmentConfiguration &&
        signedUrlApiEndpoint == other.signedUrlApiEndpoint &&
        attachmentApiEndpoint == other.attachmentApiEndpoint &&
        signedUrlFormApiEndpoint == other.signedUrlFormApiEndpoint;
  }

  @override
  int get hashCode => Object.hash(
        signedUrlApiEndpoint,
        attachmentApiEndpoint,
        signedUrlFormApiEndpoint,
      );
}

/// Converts a [configString] to an actual map of [ApptiveGridEnvironment] and [ApptiveGridConfiguration]
///
/// More Info on how to get a [configString] will follow later
Map<ApptiveGridEnvironment, AttachmentConfiguration?>
    attachmentConfigurationMapFromConfigString(String configString) {
  final json =
      jsonDecode(const Utf8Decoder().convert(base64Decode(configString)));

  final map = <ApptiveGridEnvironment, AttachmentConfiguration?>{};
  map[ApptiveGridEnvironment.alpha] = json['alpha'] != null
      ? AttachmentConfiguration.fromJson(json['alpha'])
      : null;
  map[ApptiveGridEnvironment.beta] = json['beta'] != null
      ? AttachmentConfiguration.fromJson(json['beta'])
      : null;
  map[ApptiveGridEnvironment.production] = json['production'] != null
      ? AttachmentConfiguration.fromJson(json['production'])
      : null;
  return map;
}
