part of apptive_grid_model;

class AttachmentConfiguration {
  AttachmentConfiguration({
    required this.signedUrlApiEndpoint,
    required this.attachmentApiEndpoint,
  });

  factory AttachmentConfiguration.fromJson(Map<String, dynamic> json) {
    return AttachmentConfiguration(
      signedUrlApiEndpoint: json['signedUrl'],
      attachmentApiEndpoint: json['storageUrl'],
    );
  }

  final String signedUrlApiEndpoint;
  final String attachmentApiEndpoint;

  @override
  String toString() {
    return 'AttachmentConfiguration(signedUrlApiEndpoint: $signedUrlApiEndpoint, attachmentApiEndpoint: $attachmentApiEndpoint)';
  }

  @override
  bool operator ==(Object other) {
    return other is AttachmentConfiguration &&
        signedUrlApiEndpoint == other.signedUrlApiEndpoint &&
        attachmentApiEndpoint == other.attachmentApiEndpoint;
  }

  @override
  int get hashCode => toString().hashCode;
}

Map<ApptiveGridEnvironment, AttachmentConfiguration?>
    attachmentConfigurationMapFromConfigString(String configString) {
  final json =
      jsonDecode((const Utf8Decoder()).convert(base64Decode(configString)));

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
