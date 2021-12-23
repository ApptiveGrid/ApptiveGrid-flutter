import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_form/managers/permission_manager.dart';
import 'package:apptive_grid_form/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/widgets/form_widget/attachment_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

/// [PopupMenuButton] that presents different options to pick Attachments.
///
/// Users can chosse to add Attachment from Camera, Image Gallery and Files
class AddAttachmentButton extends StatefulWidget {
  /// Creates a new PopupMenuButton
  const AddAttachmentButton({Key? key, this.onAttachmentsAdded})
      : super(key: key);

  /// Callback invoked when the user has added new Attachments
  final void Function(List<Attachment>?)? onAttachmentsAdded;

  @override
  _AddAttachmentButtonState createState() => _AddAttachmentButtonState();
}

class _AddAttachmentButtonState extends State<AddAttachmentButton> {
  bool _hasCamera = false;

  final _popupKey = GlobalKey<PopupMenuButtonState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<PermissionManager>(context)
        .checkPermission(Permission.camera)
        .then((cameraStatus) {
      if (cameraStatus != PermissionStatus.permanentlyDenied) {
        setState(() {
          _hasCamera = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ApptiveGridLocalization.of(context)!;
    return PopupMenuButton<_SourceOption>(
      enableFeedback: false,
      key: _popupKey,
      itemBuilder: (context) {
        return [
          if (_hasCamera)
            PopupMenuItem(
              value: _SourceOption.camera,
              child: _SourceOptionPopupItem(
                label: l10n.attachmentSourceCamera,
                icon: _SourceOption.camera.icon,
              ),
            ),
          PopupMenuItem(
            value: _SourceOption.gallery,
            child: _SourceOptionPopupItem(
              label: l10n.attachmentSourceGallery,
              icon: _SourceOption.gallery.icon,
            ),
          ),
          PopupMenuItem(
            value: _SourceOption.files,
            child: _SourceOptionPopupItem(
              label: l10n.attachmentSourceFiles,
              icon: _SourceOption.files.icon,
            ),
          ),
        ];
      },
      onSelected: (option) async {
        late final Future<List<Attachment>?> attachmentSelection;
        switch (option) {
          case _SourceOption.files:
            attachmentSelection = _pickFromFiles();
            break;
          case _SourceOption.gallery:
            attachmentSelection = _pickFromImageLibrary();
            break;
          case _SourceOption.camera:
            attachmentSelection = _takePicture();
            break;
        }
        final attachments = await attachmentSelection;
        if (attachments != null) {
          widget.onAttachmentsAdded?.call(attachments);
        }
      },
      child: TextButton(
        onPressed: _popupKey.currentState?.showButtonMenu,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add),
            Text(l10n.addAttachment),
          ],
        ),
      ),
    );
  }

  Future<List<Attachment>?> _pickFromFiles() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: true, withData: true, type: FileType.any);

    if (result != null) {
      final newAttachments = <Attachment>[];
      for (final file in result.files) {
        final attachment = Attachment(
          name: file.name,
          url: ApptiveGrid.getClient(context, listen: false)
              .createAttachmentUrl(file.name),
          type: lookupMimeType(file.name) ?? '',
        );
        Provider.of<AttachmentManager>(context, listen: false)
            .addAttachment(attachment, file.bytes);
        newAttachments.add(attachment);
      }
      return newAttachments;
    }
  }

  Future<List<Attachment>?> _pickFromImageLibrary() async {
    final result = await ImagePicker().pickMultiImage();

    if (result != null && result.isNotEmpty) {
      final newAttachments = <Attachment>[];
      for (final file in result) {
        final attachment = Attachment(
          name: file.name,
          url: ApptiveGrid.getClient(context, listen: false)
              .createAttachmentUrl(file.name),
          type: file.mimeType ?? lookupMimeType(file.name) ?? '',
        );
        final bytes = await file.readAsBytes();
        Provider.of<AttachmentManager>(context, listen: false)
            .addAttachment(attachment, bytes);
        newAttachments.add(attachment);
      }
      return newAttachments;
    }
  }

  Future<List<Attachment>?> _takePicture() async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);

    if (file != null) {
      final newAttachment = Attachment(
        name: file.name,
        url: ApptiveGrid.getClient(context, listen: false)
            .createAttachmentUrl(file.name),
        type: file.mimeType ?? lookupMimeType(file.name) ?? '',
      );
      final bytes = await file.readAsBytes();
      Provider.of<AttachmentManager>(context, listen: false)
          .addAttachment(newAttachment, bytes);
      return [newAttachment];
    }
  }
}

class _SourceOptionPopupItem extends StatelessWidget {
  const _SourceOptionPopupItem({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(label)),
        Icon(icon),
      ],
    );
  }
}

enum _SourceOption { files, gallery, camera }

extension _SourceOptionX on _SourceOption {
  IconData get icon {
    final isApple = UniversalPlatform.isMacOS || UniversalPlatform.isIOS;
    switch (this) {
      case _SourceOption.files:
        if (isApple) {
          return CupertinoIcons.folder;
        } else {
          return Icons.folder;
        }
      case _SourceOption.gallery:
        if (isApple) {
          return CupertinoIcons.photo_on_rectangle;
        } else {
          return Icons.photo;
        }
      case _SourceOption.camera:
        if (isApple) {
          return CupertinoIcons.camera;
        } else {
          return Icons.camera_alt;
        }
    }
  }
}
