import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/widgets/form_widget/form_widget_helpers.dart';
import 'package:flutter/material.dart';

/// FormComponent Widget to display a [FormComponent<StringDataEntity>]
class TextFormWidget extends StatefulWidget {
  /// Creates a [TextFormField] to show and edit Text contained in [component]
  const TextFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<StringDataEntity> component;

  @override
  State<TextFormWidget> createState() => _TextFormWidgetState();
}

class _TextFormWidgetState extends State<TextFormWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.component.data.value ?? '';
    _controller.addListener(() {
      widget.component.data.value = _controller.text;
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
      validator: (input) {
        if (widget.component.required && (input == null || input.isEmpty)) {
          return ApptiveGridLocalization.of(context)!
              .fieldIsRequired(widget.component.property);
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      minLines: widget.component.options.multi ? 3 : 1,
      maxLines: widget.component.options.multi ? null : 1,
      decoration: widget.component.baseDecoration,
    );
  }
}
