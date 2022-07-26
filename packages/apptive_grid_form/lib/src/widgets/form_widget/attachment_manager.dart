import 'package:apptive_grid_form/apptive_grid_form.dart';

/// Manages Attachment Actions for a [ApptiveGridFormData] Widget
class AttachmentManager {
  /// Creates a new AttachmentManager for [formData]
  AttachmentManager(this.formData);

  /// FormData that should receive Attachment Actions
  final FormData? formData;

  /// Adds an Attachment
  void addAttachment(Attachment attachment, String? path) {
    formData?.attachmentActions[attachment] =
        AddAttachmentAction(path: path, attachment: attachment);
  }

  /// Removes an Attachment. Used for deleting Attachments
  void removeAttachment(Attachment attachment) {
    final actionType = formData?.attachmentActions[attachment]?.type;
    if (actionType == null) {
      formData?.attachmentActions[attachment] =
          DeleteAttachmentAction(attachment: attachment);
    } else if (actionType == AttachmentActionType.add) {
      formData?.attachmentActions.remove(attachment);
    }
  }
}
