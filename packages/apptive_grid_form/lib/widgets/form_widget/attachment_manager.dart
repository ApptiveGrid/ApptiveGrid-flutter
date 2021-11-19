import 'dart:typed_data';

import 'package:apptive_grid_form/apptive_grid_form.dart';

class AttachmentManager {
  AttachmentManager(this.formData);

  final FormData? formData;

  void addAttachment(Attachment attachment, Uint8List? data) {
    formData?.attachmentActions[attachment] =
        AddAttachmentAction(byteData: data, attachment: attachment);
  }

  Uint8List? removeAttachment(Attachment attachment) {
    final actionType = formData?.attachmentActions[attachment]?.type;
    if (actionType == null) {
      formData?.attachmentActions[attachment] =
          DeleteAttachmentAction(attachment: attachment);
    } else if (actionType == AttachmentActionType.add) {
      formData?.attachmentActions.remove(attachment);
    }
  }
}
