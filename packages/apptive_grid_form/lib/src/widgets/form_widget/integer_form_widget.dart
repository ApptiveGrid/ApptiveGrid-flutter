import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/form_widget_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// FormComponent Widget to display a [IntegerFormComponent]
class IntegerFormWidget extends StatefulWidget {
  /// Creates a [TextFormField] to show and edit an integer contained in [component]
  const IntegerFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<IntegerDataEntity> component;

  @override
  State<IntegerFormWidget> createState() => _IntegerFormWidgetState();
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
