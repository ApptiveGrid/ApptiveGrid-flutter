part of active_grid_model;

/// Abstract class for additional options for a [FormComponent]
abstract class FormComponentOptions {
  /// Serializes [FormComponentOptions] to json
  Map<String, dynamic> toJson();
}

/// [FormComponentOptions] without any content
class StubComponentOptions extends FormComponentOptions {
  /// Creates Options
  StubComponentOptions();

  /// Deserializes [json] into [StubComponentOptions]
  StubComponentOptions.fromJson(Map<String, dynamic> json);

  /// Serializes [StubComponentOptions] to json
  @override
  Map<String, dynamic> toJson() => {};

  @override
  String toString() {
    return runtimeType.toString();
  }

  @override
  bool operator ==(Object other) {
    return other is StubComponentOptions;
  }

  @override
  int get hashCode => toString().hashCode;
}

/// [FormComponentOptions] for Text Based Components
class TextComponentOptions extends FormComponentOptions {
  /// Creates Options
  TextComponentOptions(
      {this.multi = false,
      this.placeholder = '',
      this.description = '',
      this.label});

  /// Deserializes [json] into [TextComponentOptions]
  TextComponentOptions.fromJson(Map<String, dynamic> json)
      : multi = json['multi'],
        placeholder = json['placeholder'],
        description = json['description'],
        label = json['label'];

  /// Determines if the Textfield is growable
  final bool multi;

  /// Placeholder Text
  final String placeholder;

  /// Description that descibes the Component
  final String description;

  /// Label to be used instead of [FormComponent.property]
  final String label;

  /// Serializes [TextComponentOptions] to json
  @override
  Map<String, dynamic> toJson() => {
        'multi': multi,
        'placeholder': placeholder,
        'description': description,
        'label': label
      };

  @override
  String toString() {
    return 'TextComponentOptions(${toJson()}';
  }

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
