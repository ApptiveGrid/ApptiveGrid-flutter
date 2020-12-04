part of active_grid_form_widgets;

Widget fromModel(model.FormComponent component) {
  switch(component.type) {
    case model.FormType.text:
      return FormComponentText(component: component,);
    case model.FormType.dateTime:
      return FormComponentDateTime(component: component,);
    case model.FormType.date:
      return FormComponentDate(component: component,);
    case model.FormType.integer:
      return FormComponentNumber(component: component,);
    case model.FormType.checkbox:
      return FormComponentCheckBox(component: component,);
    case model.FormType.unkown:
    default:
      throw ArgumentError();
  }
}
