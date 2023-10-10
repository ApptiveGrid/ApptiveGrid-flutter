/// The AfterSubmitAction class represents an action to be taken after a form
/// is submitted.
class AfterSubmitAction {
  /// Creates a new instance of the AfterSubmitAction class from the given JSON
  /// data.
  factory AfterSubmitAction.fromJson(dynamic json) => switch (json) {
        {
          'action': String action,
          'buttonTitle': String? buttonTitle,
          'trigger': String? trigger,
          'delay': int? delay,
          'targetUrl': String? targetUrl,
        } =>
          AfterSubmitAction(
            type: AfterSubmitActionType.values
                .firstWhere((type) => type.name == action),
            buttonTitle: buttonTitle,
            trigger: trigger != null
                ? AfterSubmitActionTrigger.values
                    .firstWhere((e) => e.name == trigger)
                : null,
            delay: delay != null ? Duration(seconds: delay) : null,
            targetUrl: targetUrl != null ? Uri.parse(targetUrl) : null,
          ),
        _ => throw ArgumentError.value(
            json,
            'Invalid AfterSubmitAction json: $json',
          ),
      };

  /// Creates a new instance of the AfterSubmitAction class.
  const AfterSubmitAction({
    required this.type,
    this.buttonTitle,
    this.trigger,
    this.delay,
    this.targetUrl,
  });

  /// The type of the action to be taken after form submission.
  final AfterSubmitActionType type;

  /// The title of the button that was clicked to trigger the action, if
  /// applicable.
  final String? buttonTitle;

  /// The trigger that caused the action to be taken, if applicable.
  final AfterSubmitActionTrigger? trigger;

  /// The delay before the action is taken, if applicable.
  final Duration? delay;

  /// The URL to redirect to after the action is taken, if applicable.
  final Uri? targetUrl;

  /// Converts the AfterSubmitAction to a JSON.
  Map<String, dynamic> toJson() {
    return {
      'action': type.name,
      if (buttonTitle != null) 'buttonTitle': buttonTitle,
      if (trigger != null) 'trigger': trigger!.name,
      if (delay != null) 'delay': delay!.inSeconds,
      if (targetUrl != null) 'targetUrl': targetUrl!.toString(),
    };
  }

  @override
  String toString() {
    return 'AfterSubmitAction(type: $type, buttonTitle: $buttonTitle, trigger: $trigger, delay: $delay, targetUrl: $targetUrl)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AfterSubmitAction &&
          other.type == type &&
          other.buttonTitle == buttonTitle &&
          other.trigger == trigger &&
          other.delay == delay &&
          other.targetUrl == targetUrl;

  @override
  int get hashCode => Object.hash(
        type,
        buttonTitle,
        trigger,
        delay,
        targetUrl,
      );
}

/// The type of an AfterSubmitAction.
enum AfterSubmitActionType {
  /// An additional answer will be requested from the user.
  additionalAnswer,

  /// A redirect will happen after the form is submitted.
  redirect,

  /// No action will be taken.
  none,
}

/// The trigger of an AfterSubmitAction.
enum AfterSubmitActionTrigger {
  /// The action was triggered by a button click.
  button,

  /// The action was triggered automatically.
  auto,
}
