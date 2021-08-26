part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [DecimalFormComponent]
class DecimalFormWidget extends StatefulWidget {
  /// Creates a [TextFormField] to show and edit an integer contained in [component]
  const DecimalFormWidget({Key? key, required this.component})
      : super(key: key);

  /// Component this Widget should reflect
  final DecimalFormComponent component;

  @override
  _DecimalFormWidgetState createState() => _DecimalFormWidgetState();
}

class _DecimalFormWidgetState extends State<DecimalFormWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.component.data.value != null) {
      _controller.text = widget.component.data.value!.toString();
    }
    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        if (double.tryParse(_controller.text.replaceAll(',', '.')) != null) {
          widget.component.data.value =
              double.parse(_controller.text.replaceAll(',', '.'));
        } else {
          _controller.text = _controller.text
              .substring(0, max(0, _controller.text.length - 1));
          _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length));
        }
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
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+'))],
      keyboardType:
          TextInputType.numberWithOptions(signed: true, decimal: true),
      decoration: InputDecoration(
        helperText: widget.component.options.description,
        helperMaxLines: 100,
        labelText: widget.component.options.label ?? widget.component.property,
        hintText: widget.component.options.placeholder,
      ),
    );
  }
}
