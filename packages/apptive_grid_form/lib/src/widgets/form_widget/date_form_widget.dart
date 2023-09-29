import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/form_widget_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// FormComponent Widget to display a [DateFormComponent]
class DateFormWidget extends StatefulWidget {
  /// Creates a Widget to display and select a Date contained in [component]
  ///
  /// Clicking on this will show a DatePicker using [showDatePicker]
  const DateFormWidget({
    super.key,
    required this.component,
    this.enabled = true,
  });

  /// Component this Widget should reflect
  final FormComponent<DateDataEntity> component;

  /// Flag whether the widget is enabled. Defaults to `true`
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _DateFormWidgetState();
}

class _DateFormWidgetState extends State<DateFormWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormFieldState> _formKey = GlobalKey<FormFieldState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final locale = Localizations.maybeLocaleOf(context)?.toString();
    final dateFormat = DateFormat.yMd(locale);
    if (widget.component.data.value != null) {
      final dateString = dateFormat.format(widget.component.data.value!);
      _controller.text = dateString;
    }
    return InkWell(
      onTap: widget.enabled
          ? () {
              final initialDate = widget.component.data.value ?? DateTime.now();
              showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: DateTime.fromMillisecondsSinceEpoch(
                  const Duration(days: 100000000).inMilliseconds,
                ),
              ).then((value) {
                if (value != null) {
                  _formKey.currentState!.didChange(dateFormat.format(value));
                  setState(() {
                    widget.component.data.value = value;
                  });
                }
              });
            }
          : null,
      child: AbsorbPointer(
        child: TextFormField(
          key: _formKey,
          controller: _controller,
          validator: (input) {
            if (widget.component.required && (input == null || input.isEmpty)) {
              return ApptiveGridLocalization.of(context)!
                  .fieldIsRequired(widget.component.property);
            } else {
              return null;
            }
          },
          enabled: widget.enabled,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: widget.component.baseDecoration,
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
