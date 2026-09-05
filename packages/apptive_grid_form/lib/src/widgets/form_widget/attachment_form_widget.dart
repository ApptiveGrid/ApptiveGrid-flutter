import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/managers/permission_manager.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/widgets/attachment/thumbnail.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/attachment/add_attachment_button.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/attachment_manager.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/form_widget_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// FormComponent Widget to display a [FormComponent<AttachmentDataEntity>]
class AttachmentFormWidget extends StatefulWidget {
  /// Creates a Widget to display and select a Attachment contained in [component]
  const AttachmentFormWidget({
    super.key,
    required this.component,
    this.fieldProperties,
  });

  /// Component this Widget should reflect
  final FormComponent<AttachmentDataEntity> component;

  /// Per-field settings of the form. Honoured here:
  /// [FormFieldProperties.appendOnlyAttachments] keeps the attachments that
  /// exist when the form opens read-only, and
  /// [FormFieldProperties.isVideoRecorder] turns the field into a single
  /// video recording.
  final FormFieldProperties? fieldProperties;

  @override
  State<StatefulWidget> createState() => _AttachmentFormWidgetState();
}

class _AttachmentFormWidgetState extends State<AttachmentFormWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  /// Attachments the user must not remove. Captured once, like the frontend
  /// does in `created()`; a default value has already been applied by then.
  late final Set<Attachment> _protected;

  bool get _appendOnly => widget.fieldProperties?.appendOnlyAttachments == true;

  bool get _videoRecorder => widget.fieldProperties?.isVideoRecorder == true;

  @override
  void initState() {
    super.initState();
    _protected = _appendOnly ? {...?widget.component.data.value} : const {};
  }

  bool _canRemove(Attachment attachment) =>
      widget.component.enabled && !_protected.contains(attachment);

  /// The video recorder holds one clip; the button only shows while empty.
  bool get _showAddButton =>
      widget.component.enabled &&
      (!_videoRecorder || (widget.component.data.value?.isEmpty ?? true));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final attachmentManager = Provider.of<AttachmentManager>(
      context,
    );
    return Provider(
      create: (_) => const PermissionManager(),
      child: FormField<AttachmentDataEntity>(
        validator: (attachments) {
          if (widget.component.required &&
              (attachments?.value == null || attachments!.value!.isEmpty)) {
            return ApptiveGridLocalization.of(context)!
                .fieldIsRequired(widget.component.property);
          } else {
            return null;
          }
        },
        enabled: widget.component.enabled,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: widget.component.data,
        builder: (formState) {
          return InputDecorator(
            decoration: widget.component.baseDecoration.copyWith(
              errorText: formState.errorText,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              isDense: true,
              filled: false,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.component.data.value != null)
                  ...widget.component.data.value!.map(
                    (attachment) {
                      final action = attachmentManager
                          .formData?.attachmentActions[attachment];
                      final isAddAction = action is AddAttachmentAction;
                      return Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Thumbnail(
                              attachment: attachment,
                              addAttachmentAction: isAddAction ? action : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(attachment.name),
                          ),
                          if (_canRemove(attachment))
                            IconButton(
                              onPressed: () {
                                attachmentManager.removeAttachment(attachment);
                                widget.component.data.value?.remove(attachment);
                                formState.didChange(widget.component.data);
                                setState(() {});
                              },
                              icon: const Icon(Icons.close),
                            ),
                        ],
                      );
                    },
                  ),
                if (_showAddButton)
                  AddAttachmentButton(
                    mode: _videoRecorder
                        ? AddAttachmentMode.videoRecorder
                        : AddAttachmentMode.any,
                    onAttachmentsAdded: (newAttachments) =>
                        _attachmentsAdded(newAttachments, formState),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _attachmentsAdded(
    List<Attachment>? attachments,
    FormFieldState<AttachmentDataEntity> formState,
  ) {
    if (attachments != null) {
      setState(() {
        widget.component.data.value?.addAll(attachments);
        formState.didChange(widget.component.data);
      });
    }
  }
}
