/// A freeform text block inside of a form
class FormTextBlock {
  /// Deserializes [json] into a FormTextBlock Object
  factory FormTextBlock.fromJson(dynamic json) => FormTextBlock(
        id: json['id'],
        text: json['text'],
        positionOnPage: json['fieldIndex'],
        type: json['type'],
        style: json['style'],
        pageId: json['pageId'],
      );

  /// Creates a FormTextBlock Object
  FormTextBlock({
    required this.id,
    required this.pageId,
    required this.positionOnPage,
    required this.text,
    required this.type,
    required this.style,
  });

  /// Id of the block
  final String id;

  /// Page of the block in the form
  final String pageId;

  /// Position of the block in the page
  final int positionOnPage;

  /// Text of the block
  final String text;

  /// Type of the block
  ///
  /// This is currently not being used in the package. On the web frontend it is used to differentiate between different block types.
  final String type;

  /// Style of the block
  ///
  /// This is currently not being used in the package. On the web frontend it is used to differentiate between different block styles (header and paragraph).
  final String style;

  /// Serializes the FormTextBlock to a json map
  Map<String, dynamic> toJson() => {
        'id': id,
        'pageId': pageId,
        'fieldIndex': positionOnPage,
        'text': text,
        'type': type,
        'style': style,
      };

  @override
  int get hashCode => Object.hash(
        id,
        pageId,
        positionOnPage,
        text,
        type,
        style,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FormTextBlock &&
        other.id == id &&
        other.pageId == pageId &&
        other.positionOnPage == positionOnPage &&
        other.text == text &&
        other.type == type &&
        other.style == style;
  }

  @override
  String toString() {
    return 'FormTextBlock(id: $id, pageId: $pageId, positionOnPage: $positionOnPage, text: $text, type: $type, style: $style)';
  }
}
