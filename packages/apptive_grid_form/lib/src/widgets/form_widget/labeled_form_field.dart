import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart';

/// `true` if labels are displayed above their field instead of inside the
/// field's [InputDecoration]
bool labelsAboveField(BuildContext context) =>
    ApptiveGridLabelConfiguration.of(context).position ==
    ApptiveGridLabelPosition.above;

/// Returns [label] if it belongs into a field's [InputDecoration], `null` if it
/// is displayed above the field instead
///
/// Use together with [LabeledFormField] so a label is shown exactly once.
String? labelInDecoration(BuildContext context, String label) =>
    labelsAboveField(context) ? null : label;

/// Displays [label] above [child] if the [ApptiveGridLabelConfiguration] asks
/// for [ApptiveGridLabelPosition.above]
///
/// With [ApptiveGridLabelPosition.floating] this returns [child] unchanged, so
/// the label stays part of the field's own [InputDecoration].
class LabeledFormField extends StatelessWidget {
  /// Creates a new [LabeledFormField]
  const LabeledFormField({
    super.key,
    required this.label,
    required this.child,
  });

  /// Label of the field, shown above it
  final String label;

  /// The field itself
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final configuration = ApptiveGridLabelConfiguration.of(context);
    if (configuration.position != ApptiveGridLabelPosition.above) {
      return child;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            label,
            style: configuration.resolveStyle(context),
          ),
        ),
        child,
      ],
    );
  }
}
