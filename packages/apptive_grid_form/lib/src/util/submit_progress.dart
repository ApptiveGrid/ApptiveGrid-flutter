import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:flutter/material.dart';

/// A class to display progress of a form submission
sealed class SubmitProgress {
  /// Creates a new SubmitProgress
  const SubmitProgress({required this.progress});

  /// The total progress of the submission
  final double progress;
}

/// A class to display progress of submitting the form data without the attachments
class SubmittingFormProgress extends SubmitProgress {
  /// Creates a new SubmittingFormProgress
  SubmittingFormProgress({required super.progress});
}

/// A class to display progress of uploading the attachments
class UploadingAttachmentsProgress extends SubmitProgress {
  /// Creates a new UploadingAttachmentsProgress
  const UploadingAttachmentsProgress({
    required super.progress,
    required this.processedAttachments,
    required this.totalAttachments,
  });

  /// The number of already processed attachments
  final int processedAttachments;

  /// The number of all attachments
  final int totalAttachments;
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
    final message = switch (progress) {
      UploadingAttachmentsProgress(
        processedAttachments: final processedAttachments,
        totalAttachments: final totalAttachments,
      ) =>
        l10n.progressProcessAttachment(
          processed: processedAttachments,
          total: totalAttachments,
        ),
      SubmittingFormProgress() => l10n.progressSubmitForm,
    };
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
