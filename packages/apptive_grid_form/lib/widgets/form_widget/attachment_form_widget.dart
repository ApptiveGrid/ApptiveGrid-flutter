part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [AttachmentFormComponent]
class AttachmentFormWidget extends StatefulWidget {
  /// Creates a Widget to display and select a Attachment contained in [component]
  const AttachmentFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final AttachmentFormComponent component;

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
                    (attachment) => Row(
                      children: [
                        Expanded(
                          child: Text(attachment.name),
                        ),
                        IconButton(
                          onPressed: () {
                            Provider.of<AttachmentManager>(
                              context,
                              listen: false,
                            ).removeAttachment(attachment);
                            widget.component.data.value?.remove(attachment);
                            formState.didChange(widget.component.data);
                            setState(() {});
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
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
