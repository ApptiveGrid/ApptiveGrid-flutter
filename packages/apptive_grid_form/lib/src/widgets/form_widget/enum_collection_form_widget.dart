import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/form_widget_helpers.dart';
import 'package:flutter/material.dart';

/// FormComponent Widget to display a [EnumCollectionFormComponent]
class EnumCollectionFormWidget extends StatefulWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const EnumCollectionFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<EnumCollectionDataEntity> component;

  @override
  State<EnumCollectionFormWidget> createState() =>
      _EnumCollectionFormWidgetState();
}

class _EnumCollectionFormWidgetState extends State<EnumCollectionFormWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FormField<EnumCollectionDataEntity>(
      validator: (selection) {
        if (widget.component.required &&
            (selection?.value == null || selection!.value!.isEmpty)) {
          return ApptiveGridLocalization.of(context)!
              .fieldIsRequired(widget.component.property);
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: widget.component.data,
      enabled: widget.component.enabled,
      builder: (fieldState) {
        return InputDecorator(
          decoration: widget.component.baseDecoration.copyWith(
            errorText: fieldState.errorText,
            contentPadding: EdgeInsets.zero,
            filled: false,
            border: InputBorder.none,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Builder(
              builder: (context) {
                if (widget.component.type == 'multiSelectList') {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final entry in widget.component.data.options)
                        CheckboxListTile(
                          tileColor: Colors.transparent,
                          shape: Border.all(color: Colors.transparent),
                          value: widget.component.data.value?.contains(entry),
                          title: Text(entry),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: widget.component.enabled
                              ? (isSelected) =>
                                  _onSelected(entry, isSelected, fieldState)
                              : null,
                          enabled: widget.component.enabled,
                        ),
                    ],
                  );
                }
                return Wrap(
                  spacing: 4,
                  children: widget.component.data.options
                      .map(
                        (e) => ChoiceChip(
                          label: Text(e),
                          selected:
                              widget.component.data.value?.contains(e) ?? false,
                          onSelected: widget.component.enabled
                              ? (isSelected) =>
                                  _onSelected(e, isSelected, fieldState)
                              : null,
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _onSelected(String value, bool? isSelected, FormFieldState fieldState) {
    if (isSelected == true) {
      widget.component.data.value?.add(value);
    } else {
      widget.component.data.value?.remove(value);
    }
    fieldState.didChange(widget.component.data);
  }
}
