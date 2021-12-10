part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [GeolocationFormComponent]
class GeolocationFormWidget extends StatefulWidget {
  /// Creates a [Checkbox] to display a boolean value contained in [component]
  const GeolocationFormWidget({
    Key? key,
    required this.component,
  }) : super(key: key);

  /// Component this Widget should reflect
  final GeolocationFormComponent component;

  @override
  _GeolocationFormWidgetState createState() => _GeolocationFormWidgetState();
}

class _GeolocationFormWidgetState extends State<GeolocationFormWidget> {
  @override
  Widget build(BuildContext context) {
    return FormField<GeolocationDataEntity>(
      validator: (selection) {
        if (widget.component.required && (selection?.value == null)) {
          return ApptiveGridLocalization.of(context)!
              .fieldIsRequired(widget.component.property);
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (formState) {
        return Provider<LocationManager>(
          create: (providerContext) {
            return LocationManager(
                configuration: ApptiveGrid.getOptions(providerContext)
                        .formWidgetConfigurations
                        .firstWhere(
                            (element) =>
                                element is GeolocationFormWidgetConfiguration,
                            orElse: () => throw Exception(
                                'Missing GeolocationFormWidgetConfiguration in ApptiveGrid Widget'))
                    as GeolocationFormWidgetConfiguration);
          },
          builder: (_, __) => InputDecorator(
            decoration: InputDecoration(
              label: Text(
                widget.component.options.label ?? widget.component.property,
              ),
              helperText: widget.component.options.description,
              helperMaxLines: 100,
              errorText: formState.errorText,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              isDense: true,
              filled: false,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GeolocationInput(
                  location: widget.component.data.value,
                  onLocationChanged: (newLocation) {
                    _updateLocation(
                      formState: formState,
                      location: newLocation,
                    );
                  },
                ),
                AspectRatio(
                  aspectRatio: 3 / 2,
                  child: GeolocationMap(
                    location: widget.component.data.value,
                    onLocationChanged: (newLocation) {
                      _updateLocation(
                        formState: formState,
                        location: newLocation,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateLocation({
    required FormFieldState formState,
    Geolocation? location,
  }) {
    setState(() {
      widget.component.data.value = location;
    });
    formState.didChange(widget.component.data);
  }
}
