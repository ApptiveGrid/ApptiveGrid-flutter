import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/form_widget_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// FormComponent Widget to display a [FormComponent<DateTimeDataEntity>]
class DateTimeFormWidget extends StatefulWidget {
  /// Creates a Widget to display and select a Date and a Time contained in [component]
  ///
  /// Clicking on the Date part will show a DatePicker using [showDatePicker]
  /// Clicking on the Time part will show a TimePicker using [showTimePicker]
  const DateTimeFormWidget({
    super.key,
    required this.component,
    this.enabled = true,
  });

  /// Component this Widget should reflect
  final FormComponent<DateTimeDataEntity> component;

  /// Flag whether the widget is enabled
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _DateTimeFormWidgetState();
}

class _DateTimeFormWidgetState extends State<DateTimeFormWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      enabled: widget.enabled,
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
                  onTap: widget.enabled
                      ? () {
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
                              final oldDate =
                                  widget.component.data.value ?? value;
                              final newDate = DateTime(
                                value.year,
                                value.month,
                                value.day,
                                oldDate.hour,
                                oldDate.minute,
                                oldDate.second,
                              );
                              state.didChange(newDate);
                              setState(() {
                                widget.component.data.value = newDate;
                              });
                            }
                          });
                        }
                      : null,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        hintText: localization.dateTimeFieldDate,
                        border: InputBorder.none,
                        isDense: true,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                        enabled: widget.enabled,
                      ),
                      enabled: widget.enabled,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: InkWell(
                  onTap: widget.enabled
                      ? () {
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
                        }
                      : null,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        hintText: localization.dateTimeFieldTime,
                        isDense: true,
                        filled: false,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        enabled: widget.enabled,
                      ),
                      enabled: widget.enabled,
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
