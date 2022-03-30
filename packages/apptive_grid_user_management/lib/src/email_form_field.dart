import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Form Field for Email Input
class EmailFormField extends StatelessWidget {
  /// Creates a new EmailFormField
  const EmailFormField({
    Key? key,
    this.controller,
    this.validator,
  }) : super(key: key);

  /// Controller for the input
  final TextEditingController? controller;

  /// Input Validator
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final localization = ApptiveGridUserManagementLocalization.of(context)!;
    return TextFormField(
      controller: controller,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: localization.hintEmail,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.deny(' '),
      ],
      validator: validator,
    );
  }
}
