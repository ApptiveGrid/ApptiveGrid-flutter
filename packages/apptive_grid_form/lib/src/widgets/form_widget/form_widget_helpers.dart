import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart'
    show BuildContext, InputBorder, InputDecoration, InputDecorationTheme;

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

/// Extension on [InputDecoration]
extension InputDecorationX on InputDecoration {
  /// Uses [border] in every state of the field
  ///
  /// Setting [InputDecoration.border] alone is not enough. An
  /// [InputDecorator] picks [InputDecoration.enabledBorder],
  /// [InputDecoration.disabledBorder], [InputDecoration.focusedBorder],
  /// [InputDecoration.errorBorder] or [InputDecoration.focusedErrorBorder]
  /// depending on the field's state and only falls back to
  /// [InputDecoration.border] where the matching one is `null`. Since
  /// [InputDecoration.applyDefaults] fills the missing ones from the
  /// [InputDecorationTheme] of the embedding app, a border set through
  /// [InputDecoration.border] is overridden as soon as an app styles the
  /// individual states.
  InputDecoration borderInEveryState(InputBorder border) => copyWith(
        border: border,
        enabledBorder: border,
        disabledBorder: border,
        focusedBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
      );

  /// Hides the field's border in every state
  ///
  /// Use this for Widgets that bring their own layout and must not be boxed in
  /// by the [InputDecorationTheme] of the app they are displayed in.
  InputDecoration get withoutBorder => borderInEveryState(InputBorder.none);
}
