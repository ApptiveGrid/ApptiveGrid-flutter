part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [DateTimeFormComponent]
class DateTimeFormWidget extends StatefulWidget {
  /// Creates a Widget to display and select a Date and a Time contained in [component]
  ///
  /// Clicking on the Date part will show a DatePicker using [showDatePicker]
  /// Clicking on the Time part will show a TimePicker using [showTimePicker]
  const DateTimeFormWidget({
    Key? key,
    required this.component,
  }) : super(key: key);

  /// Component this Widget should reflect
  final DateTimeFormComponent component;

  @override
  State<StatefulWidget> createState() => _DateTimeFormWidgetState();
}

class _DateTimeFormWidgetState extends State<DateTimeFormWidget> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.component.data.value != null) {
      final locale = Localizations.maybeLocaleOf(context)?.toString();
      final dateFormat = DateFormat.yMd(locale);
      final dateString = dateFormat.format(widget.component.data.value!);
      _dateController.text = dateString;
      final timeFormat = DateFormat.jm(locale);
      final timeString = timeFormat.format(widget.component.data.value!);
      _timeController.text = timeString;
    }
    return FormField<DateTime>(
      validator: (input) {
        if (widget.component.required && input == null) {
          return ApptiveGridLocalization.of(context)!
              .fieldIsRequired(widget.component.property);
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: widget.component.data.value,
      builder: (state) {
        final localization = ApptiveGridLocalization.of(context)!;
        return InputDecorator(
          decoration: widget.component.baseDecoration.copyWith(
            errorText: state.errorText,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: InkWell(
                  onTap: () {
                    final initialDate =
                        widget.component.data.value ?? DateTime.now();
                    showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                      lastDate: DateTime.fromMillisecondsSinceEpoch(
                        const Duration(days: 100000000).inMilliseconds,
                      ),
                    ).then((value) {
                      if (value != null) {
                        state.didChange(value);
                        setState(() {
                          widget.component.data.value = value;
                        });
                      }
                    });
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        hintText: localization.dateTimeFieldDate,
                        border: InputBorder.none,
                        isDense: true,
                        filled: false,
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
                        widget.component.data.value ?? DateTime.now();
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
                            initialDate.microsecond,
                          );
                          widget.component.data.value = newDate;
                          state.didChange(newDate);
                        });
                      }
                    });
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        hintText: localization.dateTimeFieldTime,
                        isDense: true,
                        filled: false,
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
