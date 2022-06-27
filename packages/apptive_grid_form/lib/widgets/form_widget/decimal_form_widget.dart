part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [FormComponent<DecimalDataEntity>]
class DecimalFormWidget extends StatefulWidget {
  /// Creates a [TextFormField] to show and edit an integer contained in [component]
  const DecimalFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<DecimalDataEntity> component;

  @override
  State<DecimalFormWidget> createState() => _DecimalFormWidgetState();
}

class _DecimalFormWidgetState extends State<DecimalFormWidget>
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
        if (double.tryParse(_controller.text.replaceAll(',', '.')) != null) {
          widget.component.data.value =
              double.parse(_controller.text.replaceAll(',', '.'));
        } else {
          _controller.text = _controller.text
              .substring(0, max(0, _controller.text.length - 1));
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
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
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+'))],
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: true),
      decoration: widget.component.baseDecoration,
    );
  }
}
