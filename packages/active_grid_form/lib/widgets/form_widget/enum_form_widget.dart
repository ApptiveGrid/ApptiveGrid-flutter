part of active_grid_form_widgets;

/// FormComponent Widget to display a [EnumFormComponent]
class EnumFormWidget extends StatefulWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const EnumFormWidget({Key key, this.component}) : super(key: key);

  /// Component this Widget should reflect
  final EnumFormComponent component;

  @override
  _EnumFormWidgetState createState() => _EnumFormWidgetState();
}

class _EnumFormWidgetState extends State<EnumFormWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items: widget.component.data.options
          .map((e) => DropdownMenuItem(
                value: e,
                child: AbsorbPointer(absorbing: false, child: Text(e)),
              ))
          .toList(),
      onChanged: (newValue) {
        setState(() {
          widget.component.data.value = newValue;
        });
      },
      validator: (value) {
        if (widget.component.required && value == null) {
          return '${widget.component.property} is required';
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: widget.component.data.value,
      decoration: InputDecoration(
        helperText: widget.component.options.description,
        labelText: widget.component.options.label ?? widget.component.property,
      ),
    );
  }
}
