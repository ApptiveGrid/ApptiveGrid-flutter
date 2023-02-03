import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/form_widget_helpers.dart';
import 'package:flutter/material.dart';

/// FormComponent Widget to display a [BooleanFormComponent]
class CheckBoxFormWidget extends StatefulWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const CheckBoxFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<BooleanDataEntity> component;

  @override
  State<CheckBoxFormWidget> createState() => _CheckBoxFormWidgetState();
}

class _CheckBoxFormWidgetState extends State<CheckBoxFormWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FormField<bool>(
      initialValue: widget.component.data.value,
      validator: (value) {
        if (widget.component.required && !value!) {
          return 'Required';
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) {
        return InputDecorator(
          decoration: InputDecoration(
            helperText: widget.component.options.description,
            helperMaxLines: 100,
            errorText: state.errorText,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            isDense: true,
            filled: false,
          ),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.error,
              state.hasError ? BlendMode.srcATop : BlendMode.dstIn,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: widget.component.data.value,
                    onChanged: (newValue) {
                      widget.component.data.value = newValue;
                      state.didChange(newValue);
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    widget.component.baseDecoration.labelText!,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
