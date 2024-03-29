import 'package:apptive_grid_core/src/model/form/after_submit_action.dart';
import 'package:apptive_grid_core/src/model/form/form_text_block.dart';
import 'package:flutter/foundation.dart' as f;

/// Additional properties for the [FormData]
class FormDataProperties {
  /// Creates a FormDataProperties Object
  FormDataProperties({
    this.successTitle,
    this.successMessage,
    this.buttonTitle,
    this.reloadAfterSubmit,
    this.afterSubmitAction,
    this.pageIds = const [],
    this.blocks,
  });

  /// Deserializes [json] into a FormDataProperties Object
  factory FormDataProperties.fromJson(Map<String, dynamic> json) =>
      FormDataProperties(
        successTitle: json['successTitle'],
        successMessage: json['successMessage'],
        buttonTitle: json['buttonTitle'],
        reloadAfterSubmit: json['reloadAfterSubmit'],
        afterSubmitAction: json['afterSubmitAction'] != null
            ? AfterSubmitAction.fromJson(json['afterSubmitAction'])
            : null,
        pageIds: json['pageIds']?.cast<String>() ?? [],
        blocks: (json['blocks'] as List?)
            ?.map((e) => FormTextBlock.fromJson(e))
            .toList(),
      );

  /// Custom title for a successfull submission
  final String? successTitle;

  /// Custom message for a successfull submission
  final String? successMessage;

  /// Custom title for the submit button
  final String? buttonTitle;

  /// Flag for reloading and keeping the form open after submission
  final bool? reloadAfterSubmit;

  /// Custom message for a submitting an additional answer
  final AfterSubmitAction? afterSubmitAction;

  /// The ID's and order of the different page of the form
  final List<String> pageIds;

  /// List of the freeform blocks in the form
  final List<FormTextBlock>? blocks;

  /// Serializes [FormDataProperties] to json
  Map<String, dynamic> toJson() => {
        if (successTitle != null) 'successTitle': successTitle,
        if (successMessage != null) 'successMessage': successMessage,
        if (buttonTitle != null) 'buttonTitle': buttonTitle,
        if (reloadAfterSubmit != null) 'reloadAfterSubmit': reloadAfterSubmit,
        if (afterSubmitAction != null)
          'afterSubmitAction': afterSubmitAction!.toJson(),
        'pageIds': pageIds,
        if (blocks != null) 'blocks': blocks!.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() {
    return 'FormDataProperties(successTitle: $successTitle, successMessage: $successMessage, buttonTitle: $buttonTitle, reloadAfterSubmit: $reloadAfterSubmit, afterSubmitAction: $afterSubmitAction, pageIds: $pageIds, blocks: $blocks)';
  }

  @override
  bool operator ==(Object other) {
    return other is FormDataProperties &&
        successTitle == other.successTitle &&
        successMessage == other.successMessage &&
        buttonTitle == other.buttonTitle &&
        reloadAfterSubmit == other.reloadAfterSubmit &&
        afterSubmitAction == other.afterSubmitAction &&
        f.listEquals(pageIds, other.pageIds) &&
        f.listEquals(blocks, other.blocks);
  }

  @override
  int get hashCode => Object.hash(
        successTitle,
        successMessage,
        buttonTitle,
        reloadAfterSubmit,
        afterSubmitAction,
        pageIds,
        blocks,
      );
}
