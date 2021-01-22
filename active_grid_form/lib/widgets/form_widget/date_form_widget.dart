part of active_grid_form_widgets;

/// FormComponent Widget to display a [model.DateFormComponent]
class DateFormWidget extends StatefulWidget {
  /// Creates a Widget to display and select a Date contained in [component]
  ///
  /// Clicking on this will show a DatePicker using [showDatePicker]
  const DateFormWidget({Key key, this.component}) : super(key: key);

  /// Component this Widget should reflect
  final DateFormComponent component;

  @override
  State<StatefulWidget> createState() => _DateFormWidgetState();
}

class _DateFormWidgetState extends State<DateFormWidget> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormFieldState> _formKey = GlobalKey<FormFieldState>();

  @override
  Widget build(
    BuildContext context,
  ) {
    final dateFormat = DateFormat.yMd();
    if (widget.component.data.value != null) {
      final dateString = dateFormat.format(widget.component.data.value);
      _controller.text = dateString;
    }
    return InkWell(
      onTap: () {
        final initialDate = widget.component.data.value ?? DateTime.now();
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
              widget.component.data.value = value;
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
