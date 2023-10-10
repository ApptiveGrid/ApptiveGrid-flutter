/// Model for Attachment
class Attachment {
  /// Creates a FormData Object
  Attachment({
    required this.name,
    required this.url,
    required this.type,
    this.smallThumbnail,
    this.largeThumbnail,
  });

  /// Deserializes [json] into an Attachment Object
  factory Attachment.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'name': String name,
          'url': String url,
          'type': String type,
          'smallThumbnail': String? smallThumbnail,
          'largeThumbnail': String? largeThumbnail,
        } =>
          Attachment(
            name: name,
            url: Uri.parse(url),
            type: type,
            smallThumbnail:
                smallThumbnail != null ? Uri.parse(smallThumbnail) : null,
            largeThumbnail:
                largeThumbnail != null ? Uri.parse(largeThumbnail) : null,
          ),
        _ => throw ArgumentError.value(
            json,
            'Invalid Attachment json: $json',
          ),
      };

  /// Name of the Attachment
  final String name;

  /// Url where this Attachment is stored
  final Uri url;

  /// Mime Type of the type
  final String type;

  /// Uri for a small thumbnail
  final Uri? smallThumbnail;

  /// Uri for a large thumbnail
  final Uri? largeThumbnail;

  /// Serializes [Attachment] to json
  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url.toString(),
        'type': type,
        'smallThumbnail': smallThumbnail?.toString(),
        'largeThumbnail': largeThumbnail?.toString(),
      };

  @override
  String toString() {
    return 'Attachment(name: $name, url: $url, type: $type, smallThumbnail: $smallThumbnail, largeThumbnail: $largeThumbnail)';
  }

  @override
  bool operator ==(Object other) {
    return other is Attachment &&
        name == other.name &&
        url.toString() == other.url.toString() &&
        type == other.type &&
        smallThumbnail.toString() == other.smallThumbnail.toString() &&
        largeThumbnail.toString() == other.largeThumbnail.toString();
  }

  @override
  int get hashCode =>
      Object.hash(name, url, type, smallThumbnail, largeThumbnail);
}
