part of active_grid_form_widgets;

class FormComponentDateTime extends StatefulWidget {
  final model.FormComponentDateTime component;

  const FormComponentDateTime({Key key, this.component}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormComponentDateTimeState();
}

class _FormComponentDateTimeState extends State<FormComponentDateTime> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context,) {
    if (widget.component.value != null) {
      final dateFormat = DateFormat.yMd();
      final dateString = dateFormat.format(widget.component.value);
      _dateController.text = dateString;
      final timeFormat = DateFormat.jm();
      final timeString = timeFormat.format(widget.component.value);
      _timeController.text = timeString;
    }
    return Row(
      children: [
        Flexible(
          child: InkWell(
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
                controller: _dateController,
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
          ),
        ),
        Flexible(
          child: InkWell(
            onTap: () {
              final initialDate = widget.component.value ?? DateTime.now();
              showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(initialDate),)
                  .then((value) => setState(() {
                widget.component.value = DateTime(
                  initialDate.year,
                  initialDate.month,
                  initialDate.day,
                  value.hour,
                  value.minute,
                  initialDate.second,
                  initialDate.millisecond,
                  initialDate.microsecond
                );
              }));
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: _timeController,
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
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
