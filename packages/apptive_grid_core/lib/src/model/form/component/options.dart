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
    if (json
        case {
          'multi': bool? multi,
          'placeholder': String? placeholder,
          'description': String? description,
          'label': String? label,
        }) {
      return FormComponentOptions(
        multi: multi ?? false,
        placeholder: placeholder,
        description: description,
        label: label,
      );
    } else {
      throw ArgumentError.value(
        json,
        'Invalid FormComponentOptions json: $json',
      );
    }
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
