/// Represent the different types of blocks in a form
enum FormBlockType {
  /// A simple text block
  text;
}

/// Represent the different style of blocks in a form
enum FormBlockStyle {
  /// The text is displayed in a paragraph
  paragraph;
}

/// A freeform block inside of a form
class FormBlock {
  /// Deserializes [json] into a FormBlock Object
  factory FormBlock.fromJson(dynamic json) => FormBlock(
        id: json['id'],
        text: json['text'],
        fieldIndex: json['fieldIndex'],
        type: FormBlockType.values
            .firstWhere((element) => element.name == json['type']),
        style: FormBlockStyle.values
            .firstWhere((element) => element.name == json['style']),
        pageId: json['pageId'],
      );

  /// Creates a FormBlock Object
  FormBlock({
    required this.id,
    required this.pageId,
    required this.fieldIndex,
    required this.text,
    required this.type,
    required this.style,
  });

  /// Id of the block
  final String id;

  /// Page of the block in the form
  final String pageId;

  /// Position of the block in the page
  final int fieldIndex;

  /// Text of the block
  final String text;

  /// Type of the block
  final FormBlockType type;

  /// Style of the block
  final FormBlockStyle style;

  /// Serializes the FormBlock to a json map
  Map<String, dynamic> toJson() => {
        'id': id,
        'pageId': pageId,
        'fieldIndex': fieldIndex,
        'text': text,
        'type': type.name,
        'style': style.name,
      };
}
