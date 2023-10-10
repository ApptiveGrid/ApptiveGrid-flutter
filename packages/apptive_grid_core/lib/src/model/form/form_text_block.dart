/// Styles of the text blocks in a form
enum FormTextBlockStyle {
  /// The block is styled like the header of the form
  header,

  /// The block is styled like the description of the form
  paragraph;
}

/// A freeform text block inside of a form
class FormTextBlock {
  /// Deserializes [json] into a FormTextBlock Object
  factory FormTextBlock.fromJson(dynamic json) {
    if (json
        case {
          'id': String id,
          'pageId': String? pageId,
          'fieldIndex': int positionOnPage,
          'type': String type,
          'style': String style,
          'text': String text,
        }) {
      return FormTextBlock(
        id: id,
        text: text,
        positionOnPage: positionOnPage,
        type: type,
        style: FormTextBlockStyle.values.firstWhere((e) => e.name == style),
        pageId: pageId,
      );
    } else {
      throw ArgumentError.value(
        json,
        'Invalid FormTextBlock json: $json',
      );
    }
  }

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
  final String? pageId;

  /// Position of the block in the page
  final int positionOnPage;

  /// Text of the block
  final String text;

  /// Type of the block
  ///
  /// This is currently not being used in the package. On the web frontend it is used to differentiate between different block types.
  final String type;

  /// Style of the block
  final FormTextBlockStyle style;

  /// Serializes the FormTextBlock to a json map
  Map<String, dynamic> toJson() => {
        'id': id,
        'pageId': pageId,
        'fieldIndex': positionOnPage,
        'text': text,
        'type': type,
        'style': style.name,
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
