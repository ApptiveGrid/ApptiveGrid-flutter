import 'package:flutter/material.dart';

/// Form Field for a Password with a Show/Hide Switch
class PasswordFormField extends StatefulWidget {
  /// Creates a new PasswordFormField
  const PasswordFormField({
    Key? key,
    this.controller,
    this.decoration = const InputDecoration(),
    this.validator,
    this.readOnly = false,
    this.autofillHints = const [AutofillHints.password],
  }) : super(key: key);

  /// Controller for the input
  final TextEditingController? controller;

  /// Input Decoration for the Field. [InputDecoration.suffixIcon] will be overridden by a visibility Icon Switch
  final InputDecoration decoration;

  /// Input Validator
  final String? Function(String?)? validator;

  /// Defines if this field is readOnly
  final bool readOnly;

  /// Hints for auto filling
  final Iterable<String> autofillHints;

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      autocorrect: false,
      autofillHints: widget.autofillHints,
      readOnly: widget.readOnly,
      keyboardType:
          _obscureText ? TextInputType.text : TextInputType.visiblePassword,
      decoration: widget.decoration.copyWith(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: _obscureText
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
        ),
      ),
      validator: widget.validator,
    );
  }
}
