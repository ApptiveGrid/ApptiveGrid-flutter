part of apptive_grid_model;

enum AttachmentActionType {
  add,
  delete,
  rename,
}

abstract class AttachmentAction {
  AttachmentAction(this.attachment, this.type);

  final Attachment attachment;
  final AttachmentActionType type;

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

  Map<String, dynamic> toJson();
}

class AddAttachmentAction extends AttachmentAction {
  AddAttachmentAction({required this.byteData, required attachment})
      : super(attachment, AttachmentActionType.add);

  final Uint8List? byteData;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.toString(),
        'attachment': attachment.toJson(),
        'byteData': byteData,
      };
}

class DeleteAttachmentAction extends AttachmentAction {
  DeleteAttachmentAction({required attachment})
      : super(attachment, AttachmentActionType.delete);

  @override
  Map<String, dynamic> toJson() => {
        'type': type.toString(),
        'attachment': attachment.toJson(),
      };
}

class RenameAttachmentAction extends AttachmentAction {
  RenameAttachmentAction({required this.newName, required attachment})
      : super(attachment, AttachmentActionType.rename);

  final String newName;

  @override
  Map<String, dynamic> toJson() => {
        'type': type.toString(),
        'attachment': attachment.toJson(),
        'newName': newName,
      };
}
