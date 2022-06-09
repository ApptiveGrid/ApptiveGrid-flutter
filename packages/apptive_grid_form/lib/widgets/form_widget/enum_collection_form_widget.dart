part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [EnumCollectionFormComponent]
class EnumCollectionFormWidget extends StatefulWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const EnumCollectionFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final EnumCollectionFormComponent component;

  @override
  State<EnumCollectionFormWidget> createState() =>
      _EnumCollectionFormWidgetState();
}

class _EnumCollectionFormWidgetState extends State<EnumCollectionFormWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FormField<EnumCollectionDataEntity>(
      validator: (selection) {
        if (widget.component.required &&
            (selection?.value == null || selection!.value!.isEmpty)) {
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
          child: Wrap(
            spacing: 4,
            children: widget.component.data.options
                .map(
                  (e) => ChoiceChip(
                    label: Text(e),
                    selected: widget.component.data.value?.contains(e) ?? false,
                    onSelected: (isSelected) {
                      if (isSelected) {
                        widget.component.data.value?.add(e);
                      } else {
                        widget.component.data.value?.remove(e);
                      }
                      formState.didChange(widget.component.data);
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
