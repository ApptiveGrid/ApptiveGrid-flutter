import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:flutter/material.dart';

/// Represents the current step in the submit progress
enum SubmitStep {
  /// The step to upload attachments
  uploadingAttachments,

  /// The step to submit the form data
  submittingForm,
}

/// A class to display Progress of a form submission
class SubmitProgress {
  /// Creates a new SubmitProgress
  const SubmitProgress({
    required this.step,
    required this.processedAttachments,
    required this.totalAttachments,
    required this.progress,
  });

  /// The current step in the submission progress
  final SubmitStep step;

  /// The number of already processed attachments
  final int processedAttachments;

  /// The number of all attachments
  final int totalAttachments;

  /// The total progress of the submission
  final double progress;
}

/// A Widget to display [SubmitProgress]
class SubmitProgressWidget extends StatelessWidget {
  /// Creates a Widget for [progress]
  const SubmitProgressWidget({super.key, required this.progress});

  /// The [SubmitProgress] to display
  final SubmitProgress progress;

  @override
  Widget build(BuildContext context) {
    final l10n = ApptiveGridLocalization.of(context)!;
    final String message;
    switch (progress.step) {
      case SubmitStep.uploadingAttachments:
        message = l10n.progressProcessAttachment(
          processed: progress.processedAttachments,
          total: progress.totalAttachments,
        );
        break;
      case SubmitStep.submittingForm:
        message = l10n.progressSubmitForm;
        break;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(
          value: progress.progress,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
