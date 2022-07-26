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
  });

  /// Component this Widget should reflect
  final FormComponent<AttachmentDataEntity> component;

  @override
  State<StatefulWidget> createState() => _AttachmentFormWidgetState();
}

class _AttachmentFormWidgetState extends State<AttachmentFormWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
                  ...(widget.component.data.value!.map(
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
                  )).toList(),
                AddAttachmentButton(
                  onAttachmentsAdded: (newAttachments) =>
                      _attachmentsAdded(newAttachments, formState),
                )
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
