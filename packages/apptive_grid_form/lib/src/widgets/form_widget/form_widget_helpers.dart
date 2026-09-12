import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart' show BuildContext, InputDecoration;

/// Extension on [FormComponent]
extension FormComponentX on FormComponent {
  /// Label of this component as it is shown to the user
  ///
  /// For required fields this adds a `*` to indicate that the field is required
  String get labelText {
    final label = options.label ?? property;
    return required ? '$label *' : label;
  }

  /// Base Input Decoration for Form Widgets
  /// This sets label, helper and hint Texts
  ///
  /// If the [ApptiveGridLabelConfiguration] of [context] uses
  /// [ApptiveGridLabelPosition.above] the decoration carries no label. The
  /// label is displayed above the field instead, see [labelText].
  InputDecoration baseDecoration(BuildContext context) {
    final labelPosition = ApptiveGridLabelConfiguration.of(context).position;
    return InputDecoration(
      labelText:
          labelPosition == ApptiveGridLabelPosition.above ? null : labelText,
      helperText: options.description,
      helperMaxLines: 100,
      hintText: options.placeholder,
    );
  }
}
