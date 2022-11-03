import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_form/src/managers/permission_manager.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/attachment_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

/// [PopupMenuButton] that presents different options to pick Attachments.
///
/// Users can chosse to add Attachment from Camera, Image Gallery and Files
class AddAttachmentButton extends StatefulWidget {
  /// Creates a new PopupMenuButton
  const AddAttachmentButton({super.key, this.onAttachmentsAdded});

  /// Callback invoked when the user has added new Attachments
  final void Function(List<Attachment>?)? onAttachmentsAdded;

  @override
  State<AddAttachmentButton> createState() => _AddAttachmentButtonState();
}

class _AddAttachmentButtonState extends State<AddAttachmentButton> {
  bool _hasCamera = false;

  final _popupKey = GlobalKey<PopupMenuButtonState>();

  final _imagePicker = ImagePicker();

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

    if (result != null && result.files.isNotEmpty && mounted) {
      final newAttachments = <Attachment>[];
      final client = ApptiveGrid.getClient(context, listen: false);
      final attachmentManager =
          Provider.of<AttachmentManager>(context, listen: false);
      for (final file
          in result.files.where((element) => element.path != null)) {
        final attachment =
            await client.attachmentProcessor.createAttachment(file.name);
        attachmentManager.addAttachmentFromFile(attachment, file.path);
        newAttachments.add(attachment);
      }
      return newAttachments;
    } else {
      return null;
    }
  }

  Future<List<Attachment>?> _pickFromImageLibrary() async {
    final result = await _imagePicker.pickMultiImage();

    if (result.isNotEmpty && mounted) {
      final newAttachments = <Attachment>[];
      final client = ApptiveGrid.getClient(context, listen: false);
      final attachmentManager =
          Provider.of<AttachmentManager>(context, listen: false);
      for (final file in result) {
        final attachment =
            await client.attachmentProcessor.createAttachment(file.name);

        attachmentManager.addAttachmentFromFile(attachment, file.path);
        newAttachments.add(attachment);
      }
      return newAttachments;
    } else {
      return null;
    }
  }

  Future<List<Attachment>?> _takePicture() async {
    final file = await _imagePicker.pickImage(source: ImageSource.camera);

    if (file != null && mounted) {
      final client = ApptiveGrid.getClient(context, listen: false);
      final attachmentManager =
          Provider.of<AttachmentManager>(context, listen: false);
      final newAttachment =
          await client.attachmentProcessor.createAttachment(file.name);

      attachmentManager.addAttachmentFromFile(newAttachment, file.path);
      return [newAttachment];
    } else {
      return null;
    }
  }
}

class _SourceOptionPopupItem extends StatelessWidget {
  const _SourceOptionPopupItem({
    required this.label,
    required this.icon,
  });

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
