import 'package:apptive_grid_user_management/src/translation/apptive_grid_user_management_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Form Field for Email Input
class EmailFormField extends StatelessWidget {
  /// Creates a new EmailFormField
  const EmailFormField({
    super.key,
    this.controller,
    this.validator,
    this.autofillHints,
  });

  /// Controller for the input
  final TextEditingController? controller;

  /// Input Validator
  final String? Function(String?)? validator;

  /// Hints for auto filling
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    final localization = ApptiveGridUserManagementLocalization.of(context)!;
    return TextFormField(
      controller: controller,
      autofillHints: autofillHints,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
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
