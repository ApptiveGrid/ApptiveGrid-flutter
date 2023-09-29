import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/form_widget_helpers.dart';
import 'package:flutter/material.dart';

/// FormComponent Widget to display a [FormComponent<EnumDataEntity>]
class EnumFormWidget extends StatefulWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const EnumFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<EnumDataEntity> component;

  @override
  State<EnumFormWidget> createState() => _EnumFormWidgetState();
}

class _EnumFormWidgetState extends State<EnumFormWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.component.type == 'selectList') {
      return FormField<String>(
        validator: _validate,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: widget.component.data.value,
        enabled: widget.component.enabled,
        builder: (fieldState) {
          return InputDecorator(
            decoration: widget.component.baseDecoration.copyWith(
              errorText: fieldState.errorText,
              contentPadding: EdgeInsets.zero,
              filled: false,
              border: InputBorder.none,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final entry in widget.component.data.options)
                  RadioListTile<String?>(
                    tileColor: Colors.transparent,
                    shape: Border.all(color: Colors.transparent),
                    value: entry,
                    title: Text(entry),
                    groupValue: widget.component.data.value,
                    onChanged: widget.component.enabled
                        ? (newValue) {
                            fieldState.didChange(newValue);
                            _onChanged(newValue);
                          }
                        : null,
                  ),
              ],
            ),
          );
        },
      );
    }
    return DropdownButtonFormField<String>(
      isExpanded: true,
      items: widget.component.data.options
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: AbsorbPointer(absorbing: false, child: Text(e)),
            ),
          )
          .toList(),
      selectedItemBuilder: (_) => widget.component.data.options
          .map(
            (e) => Text(
              e,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
          .toList(),
      onChanged: widget.component.enabled ? _onChanged : null,
      validator: _validate,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: widget.component.data.value,
      decoration: widget.component.baseDecoration,
    );
  }

  String? _validate(String? value) {
    if (widget.component.required && value == null) {
      return ApptiveGridLocalization.of(context)!
          .fieldIsRequired(widget.component.property);
    } else {
      return null;
    }
  }

  void _onChanged(String? newValue) {
    setState(() {
      widget.component.data.value = newValue;
    });
  }
}
