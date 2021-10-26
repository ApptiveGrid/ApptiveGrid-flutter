library apptive_grid_form;

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_form/widgets/apptive_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

export 'package:apptive_grid_core/apptive_grid_core.dart';

/// A Widget to display a ApptiveGrid Form
///
/// In order to use this there needs to be a [ApptiveGrid] Widget in the Widget tree
class ApptiveGridForm extends StatefulWidget {
  /// Creates a ApptiveGridForm.
  ///
  /// The [formId] determines what Form is displayed. It works with empty and pre-filled forms.
  const ApptiveGridForm({
    Key? key,
    required this.formUri,
    this.titleStyle,
    this.contentPadding,
    this.titlePadding,
    this.hideTitle = false,
    this.onFormLoaded,
    this.onActionSuccess,
    this.onError,
  }) : super(key: key);

  /// [FormUri] of the Form to display
  ///
  /// If you copied the id from a EditLink or Preview Window on apptivegrid you should use:
  /// [FormUri..fromRedirect] with the id
  /// If you display Data gathered from a Grid you more likely want to use [FormUri..directForm]
  final FormUri formUri;

  /// Style for the Form Title. If no style is provided [headline5] of the [TextTheme] will be used
  final TextStyle? titleStyle;

  /// Padding of the Items in the Form. If no Padding is provided a EdgeInsets.all(8.0) will be used.
  final EdgeInsets? contentPadding;

  /// Padding for the title. If no Padding is provided the [contentPadding] is used
  final EdgeInsets? titlePadding;

  /// Flag to hide the form title, default is false
  final bool hideTitle;

  /// Callback after [FormData] loads successfully
  ///
  /// Use this to modify the UI Displaying the Form
  /// ```dart
  /// ApptiveGridForm(
  ///   id: [YOUR_FORM_ID],
  ///   onFormLoaded: (data) {
  ///     setState(() {
  ///       title = data.title;
  ///     });
  ///   }
  /// ),
  /// ```
  final void Function(FormData)? onFormLoaded;

  /// Callback after [FormAction] completes Successfully
  ///
  /// If this returns false the default success screen is not shown.
  /// This functionality can be used to do a custom Widget or Transition
  final Future<bool> Function(FormAction, FormData)? onActionSuccess;

  /// Callback if an Error occurs
  ///
  /// If this returns false the default error screen is not shown.
  /// This functionality can be used to do a custom Widget or Transition
  final Future<bool> Function(dynamic)? onError;

  @override
  ApptiveGridFormState createState() => ApptiveGridFormState();
}

/// [State] for an [ApptiveGridForm]. Use this to access [currentData] to get the most up to date version
class ApptiveGridFormState extends State<ApptiveGridForm> {
  FormData? _formData;
  late ApptiveGridClient _client;

  dynamic _error;

  final _dataKey = GlobalKey<ApptiveGridFormDataState>();
  /// Returns the data currently being edited
  FormData? get currentData => _dataKey.currentState?.currentData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = ApptiveGrid.getClient(context);
    _loadForm();
  }

  @override
  Widget build(BuildContext context) {
    return ApptiveGridFormData(
      key: _dataKey,
      formData: _formData,
      error: _error,
      titleStyle: widget.titleStyle,
      contentPadding: widget.contentPadding,
      titlePadding: widget.titlePadding,
      hideTitle: widget.hideTitle,
      onActionSuccess: widget.onActionSuccess,
      onError: widget.onError,
      triggerReload: _loadForm,
    );
  }

  void _loadForm() {
    _client.loadForm(formUri: widget.formUri).then((value) {
      if (widget.onFormLoaded != null) {
        widget.onFormLoaded!(value);
      }
      setState(() {
        _formData = value;
      });
    }).catchError((error) {
      _onError(error);
    });
  }

  void _onError(dynamic error) async {
    if (await widget.onError?.call(error) ?? true) {
      setState(() {
        _error = error;
      });
    }
  }
}

/// A Widget to display [FormData]
class ApptiveGridFormData extends StatefulWidget {
  /// Creates a Widget to display [formData]
  ///
  /// if [error] is not null it will display a error
  const ApptiveGridFormData({
    Key? key,
    this.formData,
    this.error,
    this.titleStyle,
    this.contentPadding,
    this.titlePadding,
    this.hideTitle = false,
    this.onActionSuccess,
    this.onError,
    this.triggerReload,
  }) : super(key: key);

  /// [FormData] that should be displayed
  final FormData? formData;

  /// Error that should be displayed. Having a error will have priority over [formData]
  final dynamic error;

  /// Style for the Form Title. If no style is provided [headline5] of the [TextTheme] will be used
  final TextStyle? titleStyle;

  /// Padding of the Items in the Form. If no Padding is provided a EdgeInsets.all(8.0) will be used.
  final EdgeInsets? contentPadding;

  /// Padding for the title. If no Padding is provided the [contentPadding] is used
  final EdgeInsets? titlePadding;

  /// Flag to hide the form title, default is false
  final bool hideTitle;

  /// Callback after [FormAction] completes Successfully
  ///
  /// If this returns false the default success screen is not shown.
  /// This functionality can be used to do a custom Widget or Transition
  final Future<bool> Function(FormAction, FormData)? onActionSuccess;

  /// Callback if an Error occurs
  ///
  /// If this returns false the default error screen is not shown.
  /// This functionality can be used to do a custom Widget or Transition
  final Future<bool> Function(dynamic)? onError;

  /// Will be called when [formData] should be reloaded
  final void Function()? triggerReload;

  @override
  ApptiveGridFormDataState createState() => ApptiveGridFormDataState();
}

/// [State] for [ApptiveGridFormData]
///
/// Use this to access [currentData]
class ApptiveGridFormDataState extends State<ApptiveGridFormData> {
  FormData? _formData;
  late ApptiveGridClient _client;

  final _formKey = GlobalKey<FormState>();

  bool _success = false;

  dynamic _error;

  bool _saved = false;

  /// Returns the current [FormData] held in this Widget
  FormData? get currentData {
    if (!_success && !_saved) {
      return _formData;
    } else {
      return null;
    }
  }

  @override
  void didUpdateWidget(covariant ApptiveGridFormData oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateView();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = ApptiveGrid.getClient(context);
  }

  void _updateView({
    bool resetFormData = true,
  }) {
    setState(() {
      if (resetFormData) {
        _formData = widget.formData != null
            ? FormData.fromJson(widget.formData!.toJson())
            : null;
      }
      _error = widget.error;
      _success = false;
      _saved = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _buildError(context);
    } else if (_saved) {
      return _buildSaved(context);
    } else if (_success) {
      return _buildSuccess(context);
    } else if (_formData == null) {
      return _buildLoading(context);
    } else {
      return _buildForm(context, _formData!);
    }
  }

  Widget _buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildForm(BuildContext context, FormData data) {
    return Form(
      key: _formKey,
      child: ListView.builder(
        itemCount: 1 + data.components.length + data.actions.length,
        itemBuilder: (context, index) {
          // Title
          if (index == 0) {
            if (widget.hideTitle) {
              return const SizedBox();
            } else {
              return Padding(
                padding: widget.titlePadding ??
                    widget.contentPadding ??
                    _defaultPadding,
                child: Text(
                  data.title,
                  style: widget.titleStyle ??
                      Theme.of(context).textTheme.headline5,
                ),
              );
            }
          } else if (index < data.components.length + 1) {
            final componentIndex = index - 1;
            return Padding(
              padding: widget.contentPadding ?? _defaultPadding,
              child: fromModel(data.components[componentIndex]),
            );
          } else {
            final actionIndex = index - 1 - data.components.length;
            return ActionButton(
              action: data.actions[actionIndex],
              onPressed: _performAction,
              child: const Text('Send'),
            );
          }
        },
      ),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32.0),
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Lottie.asset(
            'packages/apptive_grid_form/assets/success.json',
            repeat: false,
          ),
        ),
        Text(
          'Thank You!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4,
        ),
        Center(
          child: TextButton(
            onPressed: () {
              widget.triggerReload?.call();
              _updateView();
            },
            child: const Text('Send Additional Answer'),
          ),
        )
      ],
    );
  }

  Widget _buildSaved(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32.0),
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Lottie.asset(
            'packages/apptive_grid_form/assets/saved.json',
            repeat: false,
          ),
        ),
        Text(
          'The Form was saved and will be send at the next opportunity',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4,
        ),
        Center(
          child: TextButton(
            onPressed: () {
              widget.triggerReload?.call();
              _updateView();
            },
            child: const Text('Send Additional Answer'),
          ),
        )
      ],
    );
  }

  Widget _buildError(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32.0),
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Lottie.asset(
            'packages/apptive_grid_form/assets/error.json',
            repeat: false,
          ),
        ),
        Text(
          'Oops! - Error',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4,
        ),
        Center(
          child: TextButton(
            onPressed: () {
              widget.triggerReload?.call();
              _updateView(resetFormData: false);
            },
            child: const Text('Back to Form'),
          ),
        )
      ],
    );
  }

  EdgeInsets get _defaultPadding => const EdgeInsets.all(8.0);

  void _performAction(FormAction action) {
    if (_formKey.currentState!.validate()) {
      _client.performAction(action, _formData!).then((response) async {
        if (response.statusCode < 400) {
          if (await widget.onActionSuccess?.call(action, _formData!) ?? true) {
            setState(() {
              _success = true;
            });
          }
        } else {
          // FormData was saved to [ApptiveGridCache]
          _onSavedOffline();
        }
      }).catchError((error) {
        _onError(error);
      });
    }
  }

  void _onSavedOffline() {
    if(mounted) {
      setState(() {
        _saved = ApptiveGrid.getClient(context, listen: false).options.cache != null;
      });
    }
  }

  void _onError(dynamic error) async {
    if (await widget.onError?.call(error) ?? true) {
      setState(() {
        _error = error;
      });
    }
  }
}
