part of active_grid_model;

/// Abstract class for additional options for a [FormComponent]
abstract class FormComponentOptions {}

/// [FormComponentOptions] without any content
class StubComponentOptions extends FormComponentOptions {
  /// Deserializes [json] into [StubComponentOptions]
  StubComponentOptions.fromJson(Map<String, dynamic> json);

  /// Serializes [StubComponentOptions] to json
  Map<String, dynamic> toJson() => {};
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
  Map<String, dynamic> toJson() => {
        'multi': multi,
        'placeholder': placeholder,
        'description': description,
        'label': label
      };
}
