import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart';

/// Button for a Form Action used inside a [ApptiveGridForm]
@Deprecated('Use a normal ElevatedButton instead')
class ActionButton extends StatelessWidget {
  /// Creates an Action Button
  ///
  /// This uses a RaisedButton.
  const ActionButton({
    super.key,
    required this.action,
    this.child,
    required this.onPressed,
  });

  /// The action the Button represents
  final ApptiveLink action;

  /// The child Widget displayed in the Button
  final Widget? child;

  /// Called when the button is pressed
  ///
  /// Will pass the [action] back
  final void Function(ApptiveLink) onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(action),
      child: child,
    );
  }
}
