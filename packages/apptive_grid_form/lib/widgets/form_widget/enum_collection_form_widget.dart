part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [EnumCollectionFormComponent]
class EnumCollectionFormWidget extends StatefulWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const EnumCollectionFormWidget({
    Key? key,
    required this.component,
  }) : super(key: key);

  /// Component this Widget should reflect
  final EnumCollectionFormComponent component;

  @override
  _EnumCollectionFormWidgetState createState() =>
      _EnumCollectionFormWidgetState();
}

class _EnumCollectionFormWidgetState extends State<EnumCollectionFormWidget> {
  @override
  Widget build(BuildContext context) {
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
          child: Wrap(
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
