import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart';

/// A button that scans a barcode into a field, or `null` where no scanner
/// should be offered
///
/// Returns `null` unless the app provides a [BarcodeScannerConfiguration] and
/// [fieldAsksForScanner] holds. Being `null` rather than an empty Widget lets
/// it be passed to [InputDecoration.suffixIcon] directly, where a placeholder
/// would still take up space.
Widget? barcodeScanButton(
  BuildContext context, {
  required bool fieldAsksForScanner,
  required bool enabled,
  required ValueChanged<String> onScanned,
}) {
  if (!fieldAsksForScanner) {
    return null;
  }
  final configuration = ApptiveGrid.getOptions(context)
      .formWidgetConfigurations
      .whereType<BarcodeScannerConfiguration>()
      .firstOrNull;
  if (configuration == null) {
    return null;
  }
  return BarcodeScanButton(
    configuration: configuration,
    enabled: enabled,
    onScanned: onScanned,
  );
}

/// The button [barcodeScanButton] builds
class BarcodeScanButton extends StatelessWidget {
  /// Creates a new [BarcodeScanButton]
  const BarcodeScanButton({
    super.key,
    required this.configuration,
    required this.enabled,
    required this.onScanned,
  });

  /// The scanner provided by the app
  final BarcodeScannerConfiguration configuration;

  /// Whether the field this belongs to can be edited
  final bool enabled;

  /// Called with the scanned value, never with `null`
  final ValueChanged<String> onScanned;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('BarcodeScanButton'),
      tooltip: configuration.buttonTooltip,
      icon: const Icon(Icons.qr_code_scanner),
      onPressed: enabled
          ? () async {
              final scanned = await configuration.scan(context);
              if (scanned != null && scanned.isNotEmpty) {
                onScanned(scanned);
              }
            }
          : null,
    );
  }
}
