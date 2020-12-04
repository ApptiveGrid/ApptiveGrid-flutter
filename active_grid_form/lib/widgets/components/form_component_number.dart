part of active_grid_form_widgets;

class FormComponentNumber extends StatefulWidget {
  final model.FormComponentNumber component;

  const FormComponentNumber({Key key, this.component}) : super(key: key);

  @override
  _FormComponentNumberState createState() => _FormComponentNumberState();
}

class _FormComponentNumberState extends State<FormComponentNumber> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.component.value.toString();
    _controller.addListener(() {
      widget.component.value = int.parse(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return TextFormField(
      controller: _controller,
      validator: (input) {
        if (widget.component.required && input == null) {
          // TODO: Make this Message configurable
          return '${widget.component.property} is required';
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      expands: widget.component.options.multi,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        helperText: widget.component.options.description,
        labelText: widget.component.options.label ?? widget.component.property,
        hintText: widget.component.options.placeholder,
      ),
    );
  }
}
