part of active_grid_form_widgets;

/// FormComponent Widget to display a [model.FormComponentCheckBox]
class FormComponentCheckBox extends StatefulWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const FormComponentCheckBox({Key key, this.component}) : super(key: key);

  /// Component this Widget should reflect
  final model.FormComponentCheckBox component;

  @override
  _FormComponentCheckBoxState createState() => _FormComponentCheckBoxState();
}

class _FormComponentCheckBoxState extends State<FormComponentCheckBox> {
  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: widget.component.data.value,
      validator: (value) {
        if (widget.component.required && !value) {
          return 'Required';
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) {
        return InputDecorator(
          decoration: InputDecoration(
            errorText: state.errorText,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            isDense: true,
          ),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(Theme.of(context).errorColor,
                state.hasError ? BlendMode.srcATop : BlendMode.dstIn),
            child: Row(
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
                Text(widget.component.property),
              ],
            ),
          ),
        );
      },
    );
  }
}
