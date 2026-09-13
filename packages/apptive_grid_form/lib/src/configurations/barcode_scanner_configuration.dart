import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/widgets.dart';

/// [FormWidgetConfiguration] that lets Form Widgets offer a barcode or QR code
/// scanner
///
/// The package deliberately ships no scanner itself: a scanner plugin pulls in
/// native camera dependencies and a camera usage description, which every app
/// using [ApptiveGridForm] would have to carry whether or not it scans
/// anything. Providing this configuration is what turns the feature on.
///
/// ```dart
/// ApptiveGrid(
///   options: ApptiveGridOptions(
///     formWidgetConfigurations: [
///       BarcodeScannerConfiguration(
///         scan: (context) => Navigator.of(context).push<String>(
///           MaterialPageRoute(builder: (_) => const MyScannerPage()),
///         ),
///         buttonTooltip: 'Scan barcode',
///       ),
///     ],
///   ),
///   child: ...,
/// )
/// ```
///
/// A scan button is only shown where the field's
/// [FormFieldProperties.enableBarcodeScanner] is set as well, so the form's
/// configuration stays in charge of which fields offer one.
class BarcodeScannerConfiguration extends FormWidgetConfiguration {
  /// Creates a new [BarcodeScannerConfiguration]
  const BarcodeScannerConfiguration({
    required this.scan,
    this.buttonTooltip,
  });

  /// Opens the app's scanner and completes with the scanned value
  ///
  /// Complete with `null` when the user cancels or nothing was scanned; the
  /// field is left untouched in that case.
  final Future<String?> Function(BuildContext context) scan;

  /// Tooltip of the scan button
  ///
  /// This lives here rather than in [ApptiveGridTranslation] because the
  /// package's translations are generated from POEditor: a string added to
  /// them locally would be dropped by the next update. Pass a localized label
  /// from the app.
  final String? buttonTooltip;

  @override
  String toString() =>
      'BarcodeScannerConfiguration(buttonTooltip: $buttonTooltip)';
}
