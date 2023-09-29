import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/form_widget_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// FormComponent Widget to display a [FormComponent<UriDataEntity>]
class UriFormWidget extends StatefulWidget {
  /// Creates a [UriFormField] to show and edit Uri contained in [component]
  const UriFormWidget({
    super.key,
    required this.component,
    this.enabled = true,
  });

  /// Component this Widget should reflect
  final FormComponent<UriDataEntity> component;

  /// Flag whether the widget is enabled. Defaults to `true`
  final bool enabled;

  @override
  State<UriFormWidget> createState() => _UriFormWidgetState();
}

class _UriFormWidgetState extends State<UriFormWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.component.data.value?.toString() ?? '';
    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        final uri = Uri.tryParse(
          '${_controller.text.contains(':') ? '' : 'https://'}${_controller.text}',
        );
        widget.component.data.value = uri;
      } else {
        widget.component.data.value = null;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TextFormField(
      controller: _controller,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r' ')),
        FilteringTextInputFormatter.deny(RegExp(r'\n')),
        FilteringTextInputFormatter.deny(RegExp(r'\t')),
      ],
      validator: (input) {
        if (widget.component.required && (input == null || input.isEmpty)) {
          return ApptiveGridLocalization.of(context)!
              .fieldIsRequired(widget.component.property);
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.url,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      minLines: 1,
      maxLines: 1,
      decoration: widget.component.baseDecoration,
      enabled: widget.enabled,
    );
  }
}
