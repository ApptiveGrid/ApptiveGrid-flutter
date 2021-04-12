part of active_grid_form_widgets;

/// FormComponent Widget to display a [IntegerFormComponent]
class NumberFormWidget extends StatefulWidget {
  /// Creates a [TextFormField] to show and edit an integer contained in [component]
  const NumberFormWidget({Key? key, required this.component}) : super(key: key);

  /// Component this Widget should reflect
  final IntegerFormComponent component;

  @override
  _NumberFormWidgetState createState() => _NumberFormWidgetState();
}

class _NumberFormWidgetState extends State<NumberFormWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.component.data.value != null) {
      _controller.text = widget.component.data.value!.toString();
    }
    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        widget.component.data.value = int.parse(_controller.text);
      }
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
        if (widget.component.required && (input == null || input.isEmpty)) {
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
