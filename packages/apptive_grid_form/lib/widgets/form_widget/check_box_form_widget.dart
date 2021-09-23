part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [BooleanFormComponent]
class CheckBoxFormWidget extends StatefulWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const CheckBoxFormWidget({Key? key, required this.component})
      : super(key: key);

  /// Component this Widget should reflect
  final BooleanFormComponent component;

  @override
  _CheckBoxFormWidgetState createState() => _CheckBoxFormWidgetState();
}

class _CheckBoxFormWidgetState extends State<CheckBoxFormWidget> {
  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: widget.component.data.value,
      validator: (value) {
        if (widget.component.required && !value!) {
          return 'Required';
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) {
        return InputDecorator(
          decoration: InputDecoration(
            helperText: widget.component.options.description,
            helperMaxLines: 100,
            errorText: state.errorText,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            isDense: true,
            filled: false,
          ),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(Theme.of(context).errorColor,
                state.hasError ? BlendMode.srcATop : BlendMode.dstIn),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: widget.component.data.value,
                    onChanged: (newValue) {
                      widget.component.data.value = newValue;
                      state.didChange(newValue);
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(widget.component.options.label ??
                      widget.component.property),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
