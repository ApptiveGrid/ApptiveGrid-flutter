import 'package:flutter/material.dart';

/// FormWidget for Fields that should not be visible to users in Forms
/// Like [DataType.createdBy] and [DataType.createdAt]
/// This is just a SizedBox as it should not be visible to users
class EmptyFormWidget extends StatelessWidget {
  /// Creates the FormWidget
  const EmptyFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
