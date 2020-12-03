part of active_grid_form_widgets;

enum FormType { textField, datePicker, checkbox }

abstract class FormTypeExtensions {
  static FormType fromString(String value) {
    switch (value) {
      case 'textfield':
        return FormType.textField;
      case 'datePicker':
        return FormType.datePicker;
      case 'checkbox':
        return FormType.checkbox;
      default:
        throw ArgumentError(
            'No Type $value found. Supported Types are ${FormType.values}');
    }
  }
}

Widget fromModel(model.FormComponent component) {
  if(component is model.FormComponentText) {
    return FormComponentText(component: component,);
  } else if(component is model.FormComponentCheckBox) {
    return FormComponentCheckBox(component: component,);
  } else if(component is model.FormComponentDateTime) {
    return FormComponentDateTime(component: component,);
  } else {
    throw ArgumentError();
  }
}
