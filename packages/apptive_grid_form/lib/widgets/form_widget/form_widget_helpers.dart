import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart' show InputDecoration;

/// Extension on [FormComponent]
extension FormComponentX on FormComponent {
  /// Base Input Decoration for Form Widgets
  /// This sets label, helper and hint Texts
  /// For required fields it also adds a `*` to the labels to indicate that the field is required
  InputDecoration get baseDecoration {
    String label = options.label ?? property;
    if (required) {
      label = '$label *';
    }
    return InputDecoration(
      labelText: label,
      helperText: options.description,
      helperMaxLines: 100,
      hintText: options.placeholder,
    );
  }
}
