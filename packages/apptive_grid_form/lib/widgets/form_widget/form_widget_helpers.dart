import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart' show InputDecoration;

extension FormComponentX on FormComponent {
  InputDecoration get baseDecoration {
    String label = options.label ?? property;
    if (required) {
      label = '$label *';
    }
    return InputDecoration(
        labelText: label,
        helperText: options.description,
        helperMaxLines: 100,
        hintText: options is TextComponentOptions
            ? (options as TextComponentOptions).placeholder
            : null);
  }
}
