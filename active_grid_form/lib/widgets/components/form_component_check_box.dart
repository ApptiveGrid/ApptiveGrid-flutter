part of active_grid_form_widgets;

class FormComponentCheckBox extends StatefulWidget {
  final model.FormComponentCheckBox component;

  const FormComponentCheckBox({Key key, this.component}) : super(key: key);

  @override
  _FormComponentCheckBoxState createState() => _FormComponentCheckBoxState();
}

class _FormComponentCheckBoxState extends State<FormComponentCheckBox> {
  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: widget.component.value,
      validator: (value) {
        if(widget.component.required && !value) {
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
            colorFilter: ColorFilter.mode(
              Theme.of(context).errorColor,
              state.hasError ? BlendMode.srcATop : BlendMode.dstIn
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: widget.component.value,
                    onChanged: (newValue) {
                      widget.component.value = newValue;
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
