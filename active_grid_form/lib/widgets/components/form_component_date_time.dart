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
  Widget build(
    BuildContext context,
  ) {
    if (widget.component.value != null) {
      final dateFormat = DateFormat.yMd();
      final dateString = dateFormat.format(widget.component.value);
      _dateController.text = dateString;
      final timeFormat = DateFormat.jm();
      final timeString = timeFormat.format(widget.component.value);
      _timeController.text = timeString;
    }
    return FormField<DateTime>(
      validator: (input) {
        if (widget.component.required && input == null) {
          // TODO: Make this Message configurable
          return '${widget.component.property} is required';
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: widget.component.property,
            errorText: state.errorText,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: InkWell(
                  onTap: () {
                    final initialDate =
                        widget.component.value ?? DateTime.now();
                    showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                      lastDate: DateTime.fromMillisecondsSinceEpoch(
                          Duration(days: 100000000).inMilliseconds),
                    ).then((value) {
                      if (value != null) {
                        state.didChange(value);
                        setState(() {
                          widget.component.value = value;
                        });
                      }
                    });
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        hintText: 'Date',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: InkWell(
                  onTap: () {
                    final initialDate =
                        widget.component.value ?? DateTime.now();
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(initialDate),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          final newDate = DateTime(
                              initialDate.year,
                              initialDate.month,
                              initialDate.day,
                              value.hour,
                              value.minute,
                              initialDate.second,
                              initialDate.millisecond,
                              initialDate.microsecond);
                          widget.component.value = newDate;
                          state.didChange(newDate);
                        });
                      }
                    });
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        hintText: 'Time',
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
