import 'package:flutter/material.dart';

class SubmitProgress {
  const SubmitProgress({required this.message, required this.progress});

  final String message;
  final double progress;
}

class SubmitProgressWidget extends StatelessWidget {
  const SubmitProgressWidget({Key? key, required this.progress})
      : super(key: key);

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
