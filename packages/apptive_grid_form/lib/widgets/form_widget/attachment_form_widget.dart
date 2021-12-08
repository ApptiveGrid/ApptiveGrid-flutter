part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [AttachmentFormComponent]
class AttachmentFormWidget extends StatefulWidget {
  /// Creates a Widget to display and select a Attachment contained in [component]
  const AttachmentFormWidget({
    Key? key,
    required this.component,
  }) : super(key: key);

  /// Component this Widget should reflect
  final AttachmentFormComponent component;

  @override
  State<StatefulWidget> createState() => _AttachmentFormWidgetState();
}

class _AttachmentFormWidgetState extends State<AttachmentFormWidget> {
  @override
  Widget build(BuildContext context) {
    return FormField<AttachmentDataEntity>(
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
      builder: (formState) {
        return InputDecorator(
          decoration: InputDecoration(
            label: Text(
              widget.component.options.label ?? widget.component.property,
            ),
            helperText: widget.component.options.description,
            helperMaxLines: 100,
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
              ...(widget.component.data.value?.map(
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
                      ) ??
                      [])
                  .toList(),
              TextButton(
                onPressed: () {
                  _pickFile().then(
                    (value) => formState.didChange(widget.component.data),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add),
                    Text(ApptiveGridLocalization.of(context)!.addAttachment),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: true, withData: true, type: FileType.any);

    if (result != null) {
      setState(() {
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
        widget.component.data.value?.addAll(newAttachments);
      });
    }
  }
}
