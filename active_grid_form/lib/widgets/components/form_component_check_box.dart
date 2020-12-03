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
    return Row(
      children: [
        Checkbox(
          value: widget.component.value,
          onChanged: (newValue) {
            widget.component.value = newValue;
            setState(() {

            });
          },
        ),
        Text(widget.component.property),
      ],
    );
  }
}
