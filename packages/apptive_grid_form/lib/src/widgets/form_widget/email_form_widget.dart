import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/form_widget_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// FormComponent Widget to display a [FormComponent<EmailDataEntity>]
class EmailFormWidget extends StatefulWidget {
  /// Creates a [TextFormField] to show and edit Text contained in [component]
  const EmailFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<EmailDataEntity> component;

  @override
  State<EmailFormWidget> createState() => _EmailFormWidgetState();
}

class _EmailFormWidgetState extends State<EmailFormWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.component.data.value ?? '';
    _controller.addListener(() {
      widget.component.data.value = _controller.text;
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
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\S+@\S+\.\S+$')),
      ],
      minLines: 1,
      maxLines: 1,
      decoration: widget.component.baseDecoration,
      autofillHints: const {AutofillHints.email},
      keyboardType: TextInputType.emailAddress,
    );
  }
}
