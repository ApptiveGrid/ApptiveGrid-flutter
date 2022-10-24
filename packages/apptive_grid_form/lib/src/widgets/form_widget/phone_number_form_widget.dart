import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/form_widget_helpers.dart';
import 'package:flutter/material.dart';

/// FormComponent Widget to display a [FormComponent<PhoneNumberDataEntity>]
class PhoneNumberFormWidget extends StatefulWidget {
  /// Creates a [TextFormField] to show and edit Text contained in [component]
  const PhoneNumberFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<PhoneNumberDataEntity> component;

  @override
  State<PhoneNumberFormWidget> createState() => _PhoneNumberFormWidgetState();
}

class _PhoneNumberFormWidgetState extends State<PhoneNumberFormWidget>
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
      minLines: 1,
      maxLines: 1,
      decoration: widget.component.baseDecoration,
      autofillHints: const {
        AutofillHints.telephoneNumber,
        AutofillHints.telephoneNumberDevice,
        AutofillHints.telephoneNumberLocal,
      },
      keyboardType: TextInputType.phone,
    );
  }
}
