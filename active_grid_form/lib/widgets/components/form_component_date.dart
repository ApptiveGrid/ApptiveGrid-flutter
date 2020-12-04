part of active_grid_form_widgets;

class FormComponentDate extends StatefulWidget {
  final model.FormComponentDate component;

  const FormComponentDate({Key key, this.component}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormComponentDateState();
}

class _FormComponentDateState extends State<FormComponentDate> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context,) {
    if (widget.component.value != null) {
      final dateFormat = DateFormat.yMd();
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
                Duration(days: 100000000).inMilliseconds),)
        .then((value) => setState(() {
          widget.component.value = value;
        }));
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: _controller,
          validator: (input) {
            if (widget.component.required && input.isEmpty) {
              // TODO: Make this Message configurable
              return 'Required';
            } else {
              return null;
            }
          },
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
