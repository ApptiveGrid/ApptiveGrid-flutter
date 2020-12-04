part of active_grid_form_widgets;

class FormComponentText extends StatefulWidget {
  final model.FormComponentText component;

  const FormComponentText({Key key, this.component}) : super(key: key);

  @override
  _FormComponentTextState createState() => _FormComponentTextState();
}

class _FormComponentTextState extends State<FormComponentText> {

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.component.value;
    _controller.addListener(() {
      widget.component.value = _controller.text;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context,) {
    return TextFormField(
      controller: _controller,
      validator: (input) {
        if(widget.component.required && (input == null || input.isEmpty)) {
          // TODO: Make this Message configurable
          return '${widget.component.property} is required';
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      expands: widget.component.options.multi,
      decoration: InputDecoration(
        helperText: widget.component.options.description,
        labelText: widget.component.options.label?.isNotEmpty == true ? widget.component.options.label : widget.component.property,
        hintText: widget.component.options.placeholder,
      ),
    );
  }
}
