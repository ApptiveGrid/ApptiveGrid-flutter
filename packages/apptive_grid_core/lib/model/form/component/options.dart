part of apptive_grid_model;

/// Abstract class for additional options for a [FormComponent]
class FormComponentOptions {
  /// Enables const constructors
  const FormComponentOptions({
    this.description,
    this.label,
  });

  /// Deserializes [json] into [TextComponentOptions]
  FormComponentOptions.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        label = json['label'];

  /// Description that describes the Component
  final String? description;

  /// Label to be used instead of [FormComponent.property]
  final String? label;

  /// Serializes [FormComponentOptions] to json
  Map<String, dynamic> toJson() => {
        'description': description,
        'label': label,
      };

  @override
  String toString() {
    return '$runtimeType(${toJson()}';
  }

  @override
  bool operator ==(Object other) {
    return other is FormComponentOptions &&
        other is! TextComponentOptions &&
        description == other.description &&
        label == other.label;
  }

  @override
  int get hashCode => toString().hashCode;
}

/// [FormComponentOptions] for Text Based Components
class TextComponentOptions extends FormComponentOptions {
  /// Creates Options
  const TextComponentOptions({
    this.multi = false,
    this.placeholder,
    super.description,
    super.label,
  });

  /// Deserializes [json] into [TextComponentOptions]
  factory TextComponentOptions.fromJson(Map<String, dynamic> json) {
    final jsonMulti = json['multi'] ?? false;
    final jsonPlaceholder = json['placeholder'];
    final jsonDescription = json['description'];
    final jsonLabel = json['label'];

    return TextComponentOptions(
      multi: jsonMulti,
      placeholder: jsonPlaceholder,
      description: jsonDescription,
      label: jsonLabel,
    );
  }

  /// Determines if the TextField is growable defaults to false
  final bool multi;

  /// Placeholder Text
  final String? placeholder;

  /// Serializes [TextComponentOptions] to json
  @override
  Map<String, dynamic> toJson() => {
        'multi': multi,
        'placeholder': placeholder,
        'description': description,
        'label': label
      };

  @override
  bool operator ==(Object other) {
    return other is TextComponentOptions &&
        multi == other.multi &&
        placeholder == other.placeholder &&
        description == other.description &&
        label == other.label;
  }

  @override
  int get hashCode => toString().hashCode;
}
