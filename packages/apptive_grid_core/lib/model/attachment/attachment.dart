part of apptive_grid_model;

/// Model for Attachment
class Attachment {
  /// Creates a FormData Object
  Attachment({
    required this.name,
    required this.url,
    required this.type,
    this.smallThumbnail,
    this.bigThumbnail,
  });

  /// Deserializes [json] into an Attachment Object
  Attachment.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        url = Uri.parse(json['url']),
        type = json['type'],
        smallThumbnail = json['smallThumbnail'] != null
            ? Uri.parse(json['smallThumbnail'])
            : null,
        bigThumbnail = json['bigThumbnail'] != null
            ? Uri.parse(json['bigThumbnail'])
            : null;

  /// Name of the Attachment
  final String name;

  /// Url where this Attachment is stored
  final Uri url;

  /// Mime Type of the type
  final String type;

  /// Uri for a small thumbnail
  final Uri? smallThumbnail;

  /// Uri for a big thumbnail
  final Uri? bigThumbnail;

  /// Serializes [Attachment] to json
  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url.toString(),
        'type': type,
        'smallThumbnail': smallThumbnail.toString(),
        'bigThumbnail': bigThumbnail.toString(),
      };

  @override
  String toString() {
    return 'Attachment(${toJson()})';
  }

  @override
  bool operator ==(Object other) {
    return other is Attachment &&
        name == other.name &&
        url == other.url &&
        type == other.type &&
        smallThumbnail == other.smallThumbnail &&
        bigThumbnail == other.bigThumbnail;
  }

  @override
  int get hashCode => toString().hashCode;
}
