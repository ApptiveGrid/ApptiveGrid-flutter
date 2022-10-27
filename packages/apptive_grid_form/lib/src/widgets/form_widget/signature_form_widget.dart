import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/attachment_manager.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/form_widget_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  final _signatureController = HandSignatureControl();

  @override
  void initState() {
    super.initState();

    _signatureController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _signatureController.dispose();
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: widget.component.data,
      builder: (formState) {
        return GestureDetector(
          onTap: _openSignatureSheet,
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
              child: _signatureController.isFilled
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HandSignatureView.svg(
                        data: _signatureController.toSvg(
                          wrapSignature: true,
                        )!,
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.draw_outlined),
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
        return AlertDialog(
          insetPadding: const EdgeInsets.all(8),
          titlePadding: const EdgeInsets.all(16),
          contentPadding: const EdgeInsets.all(8),
          actionsPadding: const EdgeInsets.all(16),
          title: Text('Sign here'),
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
              child: Text('clear'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(
                dialogContext,
                true,
              ),
              child: Text('confirm'),
            ),
          ],
        );
      },
    ).then(
      (didConfirm) {
        setSignature(didConfirm == true ? tmpSignatureControl.paths : null);
        tmpSignatureControl.dispose();
      },
    );
  }

  void setSignature(List<CubicPath>? paths) async {
    _signatureController.clear();
    if (paths != null) {
      _signatureController.importPath(paths);
    }

    final attachmentManager =
        Provider.of<AttachmentManager>(context, listen: false);

    if (widget.component.data.value != null) {
      attachmentManager.removeAttachment(widget.component.data.value!);
    }

    final svgString = _signatureController.toSvg(wrapSignature: true);
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
}
