library active_grid_form;

import 'package:active_grid_core/active_grid_model.dart';
import 'package:active_grid_core/active_grid_network.dart';
import 'package:active_grid_form/widgets/active_grid_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  }) : super(key: key);

  /// Id of the Form to display
  final String formId;

  /// Style for the Form Title. If no style is provided [headline5] of the [TextTheme] will be used
  final TextStyle titleStyle;

  /// Padding of the Items in the Form. If no Padding is provided a EdgeInsets.all(8.0) will be used.
  final EdgeInsets contentPadding;

  /// Padding for the title. If no Padding is provided the [contentPadding] is used
  final EdgeInsets titlePadding;

  @override
  _ActiveGridFormState createState() => _ActiveGridFormState();
}

class _ActiveGridFormState extends State<ActiveGridForm> {
  FormData _formData;
  ActiveGridClient _client;

  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = Provider.of(context);
    _loadForm();
  }

  @override
  Widget build(BuildContext context) {
    if (_formData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Form(
        key: _formKey,
        child: ListView.builder(
          itemCount: 1 + _formData.components.length + _formData.actions.length,
          itemBuilder: (context, index) {
            // Title
            if (index == 0) {
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
  }

  EdgeInsets get _defaultPadding => const EdgeInsets.all(8.0);

  Future _loadForm() async {
    final data = await _client.loadForm(formId: widget.formId);
    setState(() {
      _formData = data;
    });
  }

  Future _performAction(FormAction action) async {
    if (_formKey.currentState.validate()) {
      await _client.performAction(action, _formData).then((response) {
        if (response.statusCode < 400) {
          print('Perform Action Successful');
        } else {
          print('Error performing Request ${response.body}');
        }
      });
    }
  }
}
