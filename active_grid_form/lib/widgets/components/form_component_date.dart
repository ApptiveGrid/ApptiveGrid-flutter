part of active_grid_form_widgets;

/// FormComponent Widget to display a [model.FormComponentDate]
class FormComponentDate extends StatefulWidget {
  /// Creates a Widget to display and select a Date contained in [component]
  ///
  /// Clicking on this will show a DatePicker using [showDatePicker]
  const FormComponentDate({Key key, this.component}) : super(key: key);

  /// Component this Widget should reflect
  final model.FormComponentDate component;

  @override
  State<StatefulWidget> createState() => _FormComponentDateState();
}

class _FormComponentDateState extends State<FormComponentDate> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormFieldState> _formKey = GlobalKey<FormFieldState>();

  @override
  Widget build(
    BuildContext context,
  ) {
    final dateFormat = DateFormat.yMd();
    if (widget.component.value != null) {
      final dateString = dateFormat.format(widget.component.value);
      _controller.text = dateString;
    }
    return InkWell(
      onTap: () {
        final initialDate = widget.component.value ?? DateTime.now();
        showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime.fromMillisecondsSinceEpoch(0),
          lastDate: DateTime.fromMillisecondsSinceEpoch(
              Duration(days: 100000000).inMilliseconds),
        ).then((value) {
          if (value != null) {
            _formKey.currentState.didChange(dateFormat.format(value));
            setState(() {
              widget.component.value = value;
            });
          }
        });
      },
      child: AbsorbPointer(
        child: TextFormField(
          key: _formKey,
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
          decoration: InputDecoration(
            labelText: widget.component.property,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}