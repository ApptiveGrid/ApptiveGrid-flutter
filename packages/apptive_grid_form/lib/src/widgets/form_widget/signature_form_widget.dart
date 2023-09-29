import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/attachment_manager.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/form_widget_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hand_signature/signature.dart';
import 'package:provider/provider.dart';

/// FormComponent Widget to display a [FormComponent<SignatureDataEntity>]
class SignatureFormWidget extends StatefulWidget {
  /// Creates a Widget to display and select a Signature contained in [component]
  const SignatureFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<SignatureDataEntity> component;

  @override
  State<StatefulWidget> createState() => _SignatureFormWidgetState();
}

class _SignatureFormWidgetState extends State<SignatureFormWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _isLoadingPreviousValue = true;
  String? _loadedSvg;
  final _signatureController = HandSignatureControl();

  @override
  void initState() {
    super.initState();

    if (widget.component.data.value != null) {
      _loadSignature(widget.component.data.value!);
    } else {
      _isLoadingPreviousValue = false;
    }

    _signatureController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FormField<SignatureDataEntity>(
      validator: (signature) {
        if (widget.component.required && (signature?.value == null)) {
          return ApptiveGridLocalization.of(context)!
              .fieldIsRequired(widget.component.property);
        } else {
          return null;
        }
      },
      enabled: widget.component.enabled,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: widget.component.data,
      builder: (formState) {
        return GestureDetector(
          onTap: !_isLoadingPreviousValue && widget.component.enabled
              ? _openSignatureSheet
              : null,
          child: InputDecorator(
            decoration: widget.component.baseDecoration.copyWith(
              errorText: formState.errorText,
              contentPadding: EdgeInsets.zero,
              border: const OutlineInputBorder(),
              errorBorder: const OutlineInputBorder(),
              isDense: true,
              filled: false,
            ),
            child: AspectRatio(
              aspectRatio: 2,
              child: _signatureController.isFilled || _loadedSvg != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Builder(
                        builder: (_) {
                          late String svg;
                          if (_signatureController.isFilled) {
                            svg = _signatureController.toSvg(fit: true)!;
                          } else {
                            svg = _loadedSvg!;
                          }
                          return SvgPicture.string(svg);
                        },
                      ),
                    )
                  : Center(
                      child: _isLoadingPreviousValue
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.draw_outlined),
                    ),
            ),
          ),
        );
      },
    );
  }

  void _openSignatureSheet() async {
    final tmpSignatureControl =
        HandSignatureControl.fromMap(_signatureController.toMap());
    showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(context);
        final translations = ApptiveGridLocalization.of(context)!;
        return AlertDialog(
          insetPadding: const EdgeInsets.all(8),
          titlePadding: const EdgeInsets.all(16),
          contentPadding: const EdgeInsets.all(8),
          actionsPadding: const EdgeInsets.all(16),
          title: Text(translations.signHere),
          content: AspectRatio(
            aspectRatio: 2,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.0,
                    color: theme.dividerColor,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              child: HandSignature(
                control: tmpSignatureControl,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => tmpSignatureControl.clear(),
              child: Text(translations.clear),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(
                dialogContext,
                true,
              ),
              child: Text(translations.save),
            ),
          ],
        );
      },
    ).then(
      (didConfirm) {
        _setSignature(didConfirm == true ? tmpSignatureControl.paths : null);
        tmpSignatureControl.dispose();
      },
    );
  }

  void _setSignature(List<CubicPath>? paths) async {
    _loadedSvg = null;
    _signatureController.clear();
    if (paths != null) {
      _signatureController.importPath(paths);
    }

    final attachmentManager =
        Provider.of<AttachmentManager>(context, listen: false);

    if (widget.component.data.value != null) {
      attachmentManager.removeAttachment(widget.component.data.value!);
    }

    final svgString = _signatureController.toSvg(fit: true);
    if (svgString != null) {
      final client = ApptiveGrid.getClient(context, listen: false);

      final time = DateTime.now().toIso8601String();
      final timeString = Uri.encodeQueryComponent(time);
      final attachment = await client.attachmentProcessor
          .createAttachment('signature$timeString.svg');
      attachmentManager.addAttachmentFromMemory(
        attachment,
        Uint8List.fromList(svgString.codeUnits),
      );
      widget.component.data.value = attachment;

      setState(() {});
    }
  }

  void _loadSignature(Attachment signature) async {
    final client = ApptiveGrid.getClient(context, listen: false).httpClient;
    try {
      final response = await client.get(signature.url);
      if (response.statusCode >= 400) {
        throw response;
      }
      final rawString = String.fromCharCodes(response.bodyBytes);
      final parsedSvg = SvgStringLoader(rawString).provideSvg(null);
      setState(() {
        _loadedSvg = parsedSvg;
      });
    } catch (_) {
      widget.component.data.value = null;
    } finally {
      setState(() {
        _isLoadingPreviousValue = false;
      });
    }
  }
}
