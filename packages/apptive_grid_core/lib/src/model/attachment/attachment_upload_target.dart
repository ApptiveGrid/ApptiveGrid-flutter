/// A pre-signed target to upload a single attachment file to
///
/// This is the response of performing a [ApptiveLinkType.uploadUri] or
/// [ApptiveLinkType.s3UploadUri] link. In contrast to
/// [AttachmentConfiguration] based uploads the server determines the final
/// location of the file, so [uri] is only known after requesting a target.
class AttachmentUploadTarget {
  /// Creates a new upload target
  const AttachmentUploadTarget({
    required this.presignedUri,
    required this.uri,
  });

  /// Creates a [AttachmentUploadTarget] from [json]
  factory AttachmentUploadTarget.fromJson(Map<String, dynamic> json) {
    return AttachmentUploadTarget(
      presignedUri: Uri.parse(json['presignedUri']),
      uri: Uri.parse(json['uri']),
    );
  }

  /// The url the file should be uploaded to with a `PUT` request
  ///
  /// This is a short lived pre-signed url and should not be persisted
  final Uri presignedUri;

  /// The url the uploaded file will be available at
  ///
  /// This is the url that should be stored in an [Attachment]
  final Uri uri;

  @override
  String toString() {
    return 'AttachmentUploadTarget(presignedUri: $presignedUri, uri: $uri)';
  }

  @override
  bool operator ==(Object other) {
    return other is AttachmentUploadTarget &&
        other.presignedUri == presignedUri &&
        other.uri == uri;
  }

  @override
  int get hashCode => Object.hash(presignedUri, uri);
}

/// Requests a new [AttachmentUploadTarget] from the server
///
/// [isPublic] determines whether the uploaded file should be publicly
/// accessible
typedef AttachmentUploadTargetResolver = Future<AttachmentUploadTarget>
    Function();
