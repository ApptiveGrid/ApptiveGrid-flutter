import 'package:flutter/material.dart';

/// A class to display Progress of a form submission
class SubmitProgress {
  /// Creates a new SubmitProgress
  const SubmitProgress({required this.message, required this.progress});

  /// The message to display
  final String message;

  /// The progress of the submission
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
          progress.message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall,
        )
      ],
    );
  }
}
