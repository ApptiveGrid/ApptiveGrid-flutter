part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [IntegerFormComponent]
class IntegerFormWidget extends StatefulWidget {
  /// Creates a [TextFormField] to show and edit an integer contained in [component]
  const IntegerFormWidget({
    Key? key,
    required this.component,
  }) : super(key: key);

  /// Component this Widget should reflect
  final IntegerFormComponent component;

  @override
  _IntegerFormWidgetState createState() => _IntegerFormWidgetState();
}

class _IntegerFormWidgetState extends State<IntegerFormWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();

  @override
  bool get wantKeepAlive => true;

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
  Widget build(BuildContext context) {
    super.build(context);
    return TextFormField(
      controller: _controller,
      validator: (input) {
        if (widget.component.required && (input == null || input.isEmpty)) {
          return ApptiveGridLocalization.of(context)!
              .fieldIsRequired(widget.component.property);
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      expands: widget.component.options.multi,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: const TextInputType.numberWithOptions(signed: true),
      decoration: widget.component.baseDecoration,
    );
  }
}
