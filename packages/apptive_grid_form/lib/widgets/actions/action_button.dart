part of apptive_grid_form_widgets;

/// Button for a Form Action used inside a [ApptiveGridForm]
class ActionButton extends StatelessWidget {
  /// Creates an Action Button
  ///
  /// This uses a RaisedButton.
  const ActionButton({
    Key? key,
    required this.action,
    this.child,
    required this.onPressed,
  }) : super(key: key);

  /// The action the Button represents
  final FormAction action;

  /// The child Widget displayed in the Button
  final Widget? child;

  /// Called when the button is pressed
  ///
  /// Will pass the [action] back
  final void Function(FormAction) onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => onPressed(action),
        child: child,
      ),
    );
  }
}
