part of active_grid_model;

enum FormType {
  textField, datePicker, checkbox, unkown
}

abstract class FormTypeExtensions {
  static FormType fromString(String value) {
    switch(value) {
      case 'textfield': return FormType.textField;
      case 'datePicker': return FormType.datePicker;
      case 'checkbox': return FormType.checkbox;
      default: return FormType.unkown;
    }
  }
}

abstract class FormComponent<T> {

  String get property;
  T get value;
  FormComponentOptions get options;
  bool get required;
  FormType get type;

  static FormComponent fromJson(dynamic json) {
      final type = FormTypeExtensions.fromString(json['type']);
      switch(type) {
        case FormType.textField:
          return FormComponentText.fromJson(json);
        case FormType.datePicker:
          return FormComponentDateTime.fromJson(json);
        case FormType.checkbox:
          return FormComponentCheckBox.fromJson(json);
        case FormType.unkown:
        default:
          return throw ArgumentError('No Type $type found. Supported Types are ${FormType.values.remove(FormType.unkown)}');
      }
  }

  Map<String, dynamic> toJson();
}

abstract class FormComponentOptions<T extends FormComponent>{}