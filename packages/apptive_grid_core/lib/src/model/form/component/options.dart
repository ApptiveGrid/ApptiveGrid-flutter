import 'package:apptive_grid_core/apptive_grid_core.dart';

/// [FormComponentOptions] for Text Based Components
class FormComponentOptions {
  /// Creates Options
  const FormComponentOptions({
    this.multi = false,
    this.placeholder,
    this.description,
    this.label,
  });

  /// Deserializes [json] into [FormComponentOptions]
  factory FormComponentOptions.fromJson(Map<String, dynamic> json) {
    final jsonMulti = json['multi'] ?? false;
    final jsonPlaceholder = json['placeholder'];
    final jsonDescription = json['description'];
    final jsonLabel = json['label'];

    return FormComponentOptions(
      multi: jsonMulti,
      placeholder: jsonPlaceholder,
      description: jsonDescription,
      label: jsonLabel,
    );
  }

  /// Description that describes the Component
  final String? description;

  /// Label to be used instead of [FormComponent.property]
  final String? label;

  /// Determines if the TextField is growable defaults to false
  final bool multi;

  /// Placeholder Text
  final String? placeholder;

  @override
  String toString() {
    return 'FormComponentOptions(multi: $multi, placeholder: $placeholder, description: $description, label: $label)';
  }

  /// Serializes [FormComponentOptions] to json
  Map<String, dynamic> toJson() => {
        'multi': multi,
        'placeholder': placeholder,
        'description': description,
        'label': label,
      };

  @override
  bool operator ==(Object other) {
    return other is FormComponentOptions &&
        multi == other.multi &&
        placeholder == other.placeholder &&
        description == other.description &&
        label == other.label;
  }

  @override
  int get hashCode => Object.hash(multi, placeholder, description, label);
}
