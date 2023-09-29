/// A freeform block inside of a form
class FormBlock {
  /// Deserializes [json] into a FormBlock Object
  factory FormBlock.fromJson(dynamic json) => FormBlock(
        id: json['id'],
        text: json['text'],
        fieldIndex: json['fieldIndex'],
        type: json['type'],
        style: json['style'],
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
  final String type;

  /// Style of the block
  final String style;

  /// Serializes the FormBlock to a json map
  Map<String, dynamic> toJson() => {
        'id': id,
        'pageId': pageId,
        'fieldIndex': fieldIndex,
        'text': text,
        'type': type,
        'style': style,
      };
}
