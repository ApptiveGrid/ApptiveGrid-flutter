part of 'package:apptive_grid_user_management/src/delete_account.dart';

class _LoadingStateWidget extends StatefulWidget {
  const _LoadingStateWidget({super.key, required this.child});

  final Widget child;

  @override
  State<_LoadingStateWidget> createState() => _LoadingStateWidgetState();

  static bool isLoading(BuildContext context) {
    final state =
        context.dependOnInheritedWidgetOfExactType<_InheritedLoadingState>();
    return state?.loading ?? false;
  }

  static dynamic error(BuildContext context) {
    final state =
        context.dependOnInheritedWidgetOfExactType<_InheritedLoadingState>();
    return state?.error;
  }
}

class _LoadingStateWidgetState extends State<_LoadingStateWidget> {
  bool _loading = false;
  dynamic _error;

  set loading(bool value) {
    setState(() {
      _loading = value;
      if (value) {
        _error = null;
      }
    });
  }

  set error(dynamic value) {
    setState(() {
      _error = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedLoadingState(
      loading: _loading,
      error: _error,
      child: widget.child,
    );
  }
}

class _InheritedLoadingState extends InheritedWidget {
  const _InheritedLoadingState({
    required this.loading,
    required this.error,
    required super.child,
  });

  final bool loading;
  final dynamic error;

  @override
  bool updateShouldNotify(covariant _InheritedLoadingState oldWidget) {
    return loading != oldWidget.loading || error != oldWidget.error;
  }
}
