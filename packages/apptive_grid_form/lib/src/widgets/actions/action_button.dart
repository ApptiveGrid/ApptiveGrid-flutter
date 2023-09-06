import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart';

/// Button for a Form Action used inside a [ApptiveGridForm]
class ActionButton extends StatelessWidget {
  /// Creates an Action Button
  ///
  /// This uses a RaisedButton.
  const ActionButton({
    super.key,
    this.child,
    required this.onPressed,
  });

  /// The child Widget displayed in the Button
  final Widget? child;

  /// Called when the button is pressed
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: child,
    );
  }
}
