part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [FormComponent<EnumDataEntity>]
class EnumFormWidget extends StatefulWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const EnumFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<EnumDataEntity> component;

  @override
  State<EnumFormWidget> createState() => _EnumFormWidgetState();
}

class _EnumFormWidgetState extends State<EnumFormWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DropdownButtonFormField<String>(
      isExpanded: true,
      items: widget.component.data.options
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: AbsorbPointer(absorbing: false, child: Text(e)),
            ),
          )
          .toList(),
      selectedItemBuilder: ((_) => widget.component.data.options
          .map(
            (e) => Text(
              e,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
          .toList()),
      onChanged: (newValue) {
        setState(() {
          widget.component.data.value = newValue;
        });
      },
      validator: (value) {
        if (widget.component.required && value == null) {
          return ApptiveGridLocalization.of(context)!
              .fieldIsRequired(widget.component.property);
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: widget.component.data.value,
      decoration: widget.component.baseDecoration,
    );
  }
}
