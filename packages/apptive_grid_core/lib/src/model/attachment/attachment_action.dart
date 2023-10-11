import 'dart:typed_data';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/foundation.dart' as f;

/// Attachment actions that can be performed before uploading an attachment to apptive grid
enum _AttachmentActionType {
  /// Add a new Attachment
  add,

  /// Delete an existing Attachment
  delete,

  /// Rename an Attachment
  rename,
}

/// Abstract class describing an Attachment Action
sealed class AttachmentAction {
  /// Creates a new Action of a specific [type] for an [attachment]
  AttachmentAction({required this.attachment});

  /// [Attachment] this action is performed on
  final Attachment attachment;

  /// Create a specific AttachmentAction from a json file
  static AttachmentAction fromJson(dynamic json) {
    final type = _AttachmentActionType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => throw ArgumentError.value(
        json['type'],
        'Unknown AttachmentActionType ${json['type']}',
      ),
    );
    final attachment = Attachment.fromJson(json['attachment']);
    return switch (type) {
      _AttachmentActionType.add => AddAttachmentAction(
          byteData: json['byteData'] != null
              ? Uint8List.fromList(json['byteData'].cast<int>())
              : null,
          path: json['path'],
          attachment: attachment,
        ),
      _AttachmentActionType.delete =>
        DeleteAttachmentAction(attachment: attachment),
      _AttachmentActionType.rename => RenameAttachmentAction(
          newName: json['newName'],
          attachment: attachment,
        ),
    };
  }

  /// Serializes an AttachmentAction to json
  Map<String, dynamic> toJson();
}

/// Implementation of an [AttachmentAction] for [AttachmentActionType.add]
class AddAttachmentAction extends AttachmentAction {
  /// Creates an Add Action to upload [byteData] for [attachment]
  AddAttachmentAction({this.byteData, this.path, required super.attachment})
      : assert(byteData != null || path != null);

  /// Data for new Attachment
  final Uint8List? byteData;

  /// The Path to a File for this Attachment
  final String? path;

  @override
  Map<String, dynamic> toJson() => {
        'type': _AttachmentActionType.add.name,
        'attachment': attachment.toJson(),
        'byteData': byteData?.toList(growable: false),
        'path': path,
      };

  @override
  String toString() {
    return 'AddAttachmentAction(attachment: $attachment, path: $path, byteData(byteSize): ${byteData?.lengthInBytes})';
  }

  @override
  bool operator ==(Object other) {
    return other is AddAttachmentAction &&
        other.attachment == attachment &&
        other.path == path &&
        f.listEquals(other.byteData?.toList(), byteData?.toList());
  }

  @override
  int get hashCode => Object.hash(attachment, path, byteData);
}

/// Implementation of an [AttachmentAction] for [AttachmentActionType.delete]
class DeleteAttachmentAction extends AttachmentAction {
  /// Creates an Action to delete [attachment]
  DeleteAttachmentAction({required super.attachment});

  @override
  Map<String, dynamic> toJson() => {
        'type': _AttachmentActionType.delete.name,
        'attachment': attachment.toJson(),
      };

  @override
  String toString() {
    return 'DeleteAttachmentAction(attachment: $attachment)';
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteAttachmentAction && other.attachment == attachment;
  }

  @override
  int get hashCode => attachment.hashCode;
}

/// Implementation of an [AttachmentAction] for [AttachmentActionType.delete]
class RenameAttachmentAction extends AttachmentAction {
  /// Creates an action to change the name of an [attachment] to [newName]
  RenameAttachmentAction({required this.newName, required super.attachment});

  /// New name of an attachment
  final String newName;

  @override
  Map<String, dynamic> toJson() => {
        'type': _AttachmentActionType.rename.name,
        'attachment': attachment.toJson(),
        'newName': newName,
      };

  @override
  String toString() {
    return 'RenameAttachmentAction(newName: $newName, attachment: $attachment)';
  }

  @override
  bool operator ==(Object other) {
    return other is RenameAttachmentAction &&
        other.attachment == attachment &&
        other.newName == newName;
  }

  @override
  int get hashCode => Object.hash(attachment, newName);
}
