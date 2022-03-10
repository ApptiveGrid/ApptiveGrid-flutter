part of apptive_grid_form_widgets;

/// FormComponent Widget to display a [GeolocationFormComponent]
class GeolocationFormWidget extends StatefulWidget {
  /// Creates elements to display a [Geolocation] value contained in [component]
  ///
  /// Shows a [GeolocationInput] and [GeolocationMap] Widget to allow the user to change the value
  const GeolocationFormWidget({
    Key? key,
    required this.component,
  }) : super(key: key);

  /// Component this Widget should reflect
  final GeolocationFormComponent component;

  @override
  _GeolocationFormWidgetState createState() => _GeolocationFormWidgetState();
}

class _GeolocationFormWidgetState extends State<GeolocationFormWidget>
    with AutomaticKeepAliveClientMixin {
  dynamic _error;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_error != null) {
      return const Center(
        child: Text(
          'Missing GeolocationFormWidgetConfiguration in ApptiveGrid Widget',
        ),
      );
    }
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
      initialValue: widget.component.data,
      builder: (formState) {
        return MultiProvider(
          providers: [
            Provider<LocationManager>(
              create: (providerContext) {
                final configuration = ApptiveGrid.getOptions(providerContext)
                    .formWidgetConfigurations
                    .firstWhere(
                  (element) => element is GeolocationFormWidgetConfiguration,
                  orElse: () {
                    WidgetsBinding.instance?.addPostFrameCallback((_) {
                      setState(() {
                        _error = Exception(
                          'Missing GeolocationFormWidgetConfiguration in ApptiveGrid Widget',
                        );
                      });
                    });
                    return const GeolocationFormWidgetConfiguration(
                      placesApiKey: '',
                    );
                  },
                ) as GeolocationFormWidgetConfiguration;
                return LocationManager(configuration: configuration);
              },
            ),
            Provider.value(value: const PermissionManager()),
          ],
          builder: (_, __) => InputDecorator(
            decoration: widget.component.baseDecoration.copyWith(
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
                const SizedBox(height: 4),
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
