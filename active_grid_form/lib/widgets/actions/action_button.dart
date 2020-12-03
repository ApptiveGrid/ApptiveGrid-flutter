part of active_grid_form_widgets;

class ActionButton extends StatelessWidget {
  final model.FormAction action;
  final Widget child;
  final void Function(model.FormAction) onPressed;

  const ActionButton({Key key, @required this.action, this.child, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => onPressed(action),
      child: child,
    );
  }
}
