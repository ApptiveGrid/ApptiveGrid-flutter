library active_grid_form;

import 'package:active_grid_core/active_grid_model.dart';
import 'package:active_grid_core/active_grid_network.dart';
import 'package:active_grid_form/widgets/active_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

/// A Widget to display a ActiveGrid Form
///
/// In order to use this there needs to be a [ActiveGrid] Widget in the Widget tree
class ActiveGridForm extends StatefulWidget {
  /// Creates a ActiveGridForm.
  ///
  /// The [formId] determines what Form is displayed. It works with empty and pre-filled forms.
  const ActiveGridForm({
    Key key,
    @required this.formId,
    this.titleStyle,
    this.contentPadding,
    this.titlePadding,
    this.hideTitle = false,
  }) : super(key: key);

  /// Id of the Form to display
  final String formId;

  /// Style for the Form Title. If no style is provided [headline5] of the [TextTheme] will be used
  final TextStyle titleStyle;

  /// Padding of the Items in the Form. If no Padding is provided a EdgeInsets.all(8.0) will be used.
  final EdgeInsets contentPadding;

  /// Padding for the title. If no Padding is provided the [contentPadding] is used
  final EdgeInsets titlePadding;

  /// Flag to hide the form title, default is false
  final bool hideTitle;

  @override
  _ActiveGridFormState createState() => _ActiveGridFormState();
}

class _ActiveGridFormState extends State<ActiveGridForm> {
  FormData _formData;
  ActiveGridClient _client;

  final _formKey = GlobalKey<FormState>();

  bool _success = false;

  dynamic _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = Provider.of(context);
    _loadForm();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _buildError(context);
    } else if (_success) {
      return _buildSuccess(context);
    } else if (_formData == null) {
      return _buildLoading(context);
    } else {
      return _buildForm(context);
    }
  }

  Widget _buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView.builder(
        itemCount: 1 + _formData.components.length + _formData.actions.length,
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
                  _formData.title,
                  style: widget.titleStyle ??
                      Theme.of(context).textTheme.headline5,
                ),
              );
            }
          } else if (index < _formData.components.length + 1) {
            final componentIndex = index - 1;
            return Padding(
                padding: widget.contentPadding ?? _defaultPadding,
                child: fromModel(_formData.components[componentIndex]));
          } else {
            final actionIndex = index - 1 - _formData.components.length;
            return ActionButton(
              action: _formData.actions[actionIndex],
              onPressed: _performAction,
              child: Text('Action$actionIndex'),
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
              'packages/active_grid_form/assets/success.json',
              repeat: false,
            )),
        Text(
          'Thank You!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4,
        ),
        Center(
          child: FlatButton(
              onPressed: () {
                _loadForm();
                setState(() {
                  _success = false;
                  _error = null;
                  _formData = null;
                });
              },
              child: Text('Send Additional Answer')),
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
              'packages/active_grid_form/assets/error.json',
              repeat: false,
            )),
        Text(
          'Oops! - Error',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4,
        ),
        Center(
          child: FlatButton(
              onPressed: () {
                if (_formData == null) {
                  _loadForm();
                }
                setState(() {
                  _success = false;
                  _error = null;
                });
              },
              child: Text('Back to Form')),
        )
      ],
    );
  }

  EdgeInsets get _defaultPadding => const EdgeInsets.all(8.0);

  void _loadForm() {
    _client.loadForm(formId: widget.formId).then((value) {
      setState(() {
        _formData = value;
      });
    }).catchError((error) {
      _onError(error);
    });
  }

  void _performAction(FormAction action) {
    if (_formKey.currentState.validate()) {
      _client.performAction(action, _formData).then((response) {
        if (response.statusCode < 400) {
          setState(() {
            _success = true;
          });
        } else {
          _onError(response);
        }
      }).catchError((error) {
        _onError(error);
      });
    }
  }

  void _onError(dynamic error) {
    setState(() {
      _error = error;
    });
  }
}
