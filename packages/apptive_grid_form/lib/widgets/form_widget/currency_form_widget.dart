import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/widgets/form_widget/form_widget_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// FormComponent Widget to display a [FormComponent<CurrencyDataEntity>]
class CurrencyFormWidget extends StatefulWidget {
  /// Creates a [TextFormField] to show and edit an integer contained in [component]
  const CurrencyFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<CurrencyDataEntity> component;

  @override
  State<CurrencyFormWidget> createState() => _CurrencyFormWidgetState();
}

class _CurrencyFormWidgetState extends State<CurrencyFormWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: Localizations.localeOf(context).toString(),
      symbol: NumberFormat().simpleCurrencySymbol(
        widget.component.data.currency,
      ),
    );
    return formatter.format(value);
  }

  @override
  void initState() {
    super.initState();
    if (widget.component.data.value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = _formatCurrency(widget.component.data.value!);
      });
    }
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
      expands: widget.component.options.multi,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'\d')),
        TextInputFormatter.withFunction((oldValue, newValue) {
          final cleanedInput = newValue.text.replaceAll(RegExp('[^0-9]'), '');
          double value = double.parse(cleanedInput) / 100;
          widget.component.data.value = value;

          String newText = _formatCurrency(value);

          return newValue.copyWith(
            text: newText,
            selection: oldValue.selection.copyWith(
              baseOffset: oldValue.selection.baseOffset +
                  (newText.length - oldValue.text.length),
              extentOffset: oldValue.selection.extentOffset +
                  (newText.length - oldValue.text.length),
            ),
          );
        })
      ],
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: false),
      decoration: widget.component.baseDecoration,
    );
  }
}
