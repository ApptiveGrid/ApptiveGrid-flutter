import 'package:flutter/material.dart';

/// Determines where the label of a Form Field is displayed
enum ApptiveGridLabelPosition {
  /// The label is part of the field's [InputDecoration] and floats from inside
  /// the field to its top edge once the field is focused or filled.
  ///
  /// This is the default and matches the Material Design behavior.
  floating,

  /// The label is displayed as a separate [Text] above the field.
  ///
  /// The field itself is rendered without a label, which means a
  /// `placeholder` is visible while the field is empty.
  above,
}

/// Configures how labels of Form Fields are displayed for all Widgets below
/// this in the Widget tree
///
/// [ApptiveGridForm] and [ApptiveGridFormData] insert this automatically based
/// on their `labelPosition` and `labelStyle` arguments. Insert it manually to
/// configure Form Widgets that are used outside of a full form.
class ApptiveGridLabelConfiguration extends InheritedWidget {
  /// Creates a new [ApptiveGridLabelConfiguration]
  const ApptiveGridLabelConfiguration({
    super.key,
    this.position = ApptiveGridLabelPosition.floating,
    this.style,
    required super.child,
  });

  /// Where the label of a Form Field is displayed
  final ApptiveGridLabelPosition position;

  /// Style for labels displayed with [ApptiveGridLabelPosition.above]
  ///
  /// If this is `null` the [InputDecorationTheme.labelStyle] is used, falling
  /// back to [TextTheme.titleMedium]. This way a label above a field looks the
  /// same as a floating label unless a style is provided.
  final TextStyle? style;

  /// The configuration that applies to [context], or a default configuration
  /// using [ApptiveGridLabelPosition.floating] if there is none
  static ApptiveGridLabelConfiguration of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<
          ApptiveGridLabelConfiguration>() ??
      const ApptiveGridLabelConfiguration(child: SizedBox());

  /// Resolves [style] against the [Theme] of [context]
  TextStyle? resolveStyle(BuildContext context) {
    final theme = Theme.of(context);
    return style ??
        theme.inputDecorationTheme.labelStyle ??
        theme.textTheme.titleMedium;
  }

  @override
  bool updateShouldNotify(ApptiveGridLabelConfiguration oldWidget) =>
      position != oldWidget.position || style != oldWidget.style;
}
