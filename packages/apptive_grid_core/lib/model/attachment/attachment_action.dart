part of apptive_grid_model;

/// Attachment actions that can be performed before uploading an attachment to apptive grid
enum AttachmentActionType {
  /// Add a new Attachment
  add,

  /// Delete an existing Attachment
  delete,

  /// Rename an Attachment
  rename,
}

/// Abstract class describing an Attachment Action
abstract class AttachmentAction {
  /// Creates a new Action of a specific [type] for an [attachment]
  AttachmentAction(this.attachment, this.type);

  /// [Attachment] this action is performed on
  final Attachment attachment;

  /// [AttachmentActionType] of this action
  final AttachmentActionType type;

  /// Create a specific AttachmentAction from a json file
  static AttachmentAction fromJson(dynamic json) {
    final type = AttachmentActionType.values.firstWhere(
      (element) => element.toString() == json['type'],
      orElse: () => throw ArgumentError.value(
        json['type'],
        'Unknown AttachmentActionType ${json['type']}',
      ),
    );
    final attachment = Attachment.fromJson(json['attachment']);
    switch (type) {
      case AttachmentActionType.add:
        return AddAttachmentAction(
          byteData: Uint8List.fromList(json['byteData']),
          attachment: attachment,
        );
      case AttachmentActionType.delete:
        return DeleteAttachmentAction(attachment: attachment);
      case AttachmentActionType.rename:
        return RenameAttachmentAction(
          newName: json['newName'],
          attachment: attachment,
        );
    }
  }

  /// Serializes an AttachmentAction to json
  Map<String, dynamic> toJson();
}

/// Implementation of an [AttachmentAction] for [AttachmentActionType.add]
class AddAttachmentAction extends AttachmentAction {
  /// Creates an Add Action to upload [byteData] for [attachment]
  AddAttachmentAction({required this.byteData, required attachment})
      : super(attachment, AttachmentActionType.add);

  /// Data for new Attachment
  final Uint8List? byteData;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.toString(),
        'attachment': attachment.toJson(),
        'byteData': byteData,
      };
}

/// Implementation of an [AttachmentAction] for [AttachmentActionType.delete]
class DeleteAttachmentAction extends AttachmentAction {
  /// Creates an Action to delete [attachment]
  DeleteAttachmentAction({required attachment})
      : super(attachment, AttachmentActionType.delete);

  @override
  Map<String, dynamic> toJson() => {
        'type': type.toString(),
        'attachment': attachment.toJson(),
      };
}

/// Implementation of an [AttachmentAction] for [AttachmentActionType.delete]
class RenameAttachmentAction extends AttachmentAction {
  /// Creates an action to change the name of an [attachment] to [newName]
  RenameAttachmentAction({required this.newName, required attachment})
      : super(attachment, AttachmentActionType.rename);

  /// New name of an attachment
  final String newName;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.toString(),
        'attachment': attachment.toJson(),
        'newName': newName,
      };
}
