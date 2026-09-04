import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/managers/location_manager.dart';
import 'package:apptive_grid_form/src/managers/permission_manager.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/widgets/address/country_names.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/form_widget_helpers.dart';
import 'package:apptive_grid_form/src/widgets/geolocation/geolocation_map.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

/// FormComponent Widget to display a [FormComponent<AddressDataEntity>]
class AddressFormWidget extends StatefulWidget {
  /// Creates elements to display an [Address] value contained in [component]
  const AddressFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<AddressDataEntity> component;

  @override
  State<AddressFormWidget> createState() => _AddressFormWidgetState();
}

class _AddressFormWidgetState extends State<AddressFormWidget>
    with AutomaticKeepAliveClientMixin {
  dynamic _error;
  bool _geocoding = false;
  String? _geocodingError;

  late final TextEditingController _line1Controller;
  late final TextEditingController _line2Controller;
  late final TextEditingController _cityController;
  late final TextEditingController _postCodeController;
  late final TextEditingController _stateController;
  late final TextEditingController _countryController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final value = widget.component.data.value;
    _line1Controller = TextEditingController(text: value?.line1 ?? '');
    _line2Controller = TextEditingController(text: value?.line2 ?? '');
    _cityController = TextEditingController(text: value?.city ?? '');
    _postCodeController = TextEditingController(text: value?.postCode ?? '');
    _stateController = TextEditingController(text: value?.state ?? '');
    _countryController = TextEditingController(text: value?.country ?? '');
  }

  @override
  void dispose() {
    _line1Controller.dispose();
    _line2Controller.dispose();
    _cityController.dispose();
    _postCodeController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

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
    final translations = ApptiveGridLocalization.of(context)!;
    return FormField<AddressDataEntity>(
      validator: (selection) => _validate(translations, selection),
      enabled: widget.component.enabled,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: widget.component.data,
      builder: (formState) {
        return MultiProvider(
          providers: [
            Provider<LocationManager>(
              lazy: false,
              create: (providerContext) {
                final configuration = ApptiveGrid.getOptions(providerContext)
                    .formWidgetConfigurations
                    .firstWhere(
                  (element) => element is GeolocationFormWidgetConfiguration,
                  orElse: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
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
          builder: (providerContext, __) => InputDecorator(
            decoration: widget.component.baseDecoration.copyWith(
              errorText: formState.errorText,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              filled: false,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 4),
                TextField(
                  key: const Key('AddressFormWidget.line1'),
                  controller: _line1Controller,
                  enabled: widget.component.enabled,
                  decoration: InputDecoration(
                    labelText: translations.addressLine1Label,
                    isDense: true,
                  ),
                  onChanged: (value) => _updateAddress(
                    formState,
                    (address) => address.copyWith(line1: value),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  key: const Key('AddressFormWidget.line2'),
                  controller: _line2Controller,
                  enabled: widget.component.enabled,
                  decoration: InputDecoration(
                    labelText: translations.addressLine2Label,
                    isDense: true,
                  ),
                  onChanged: (value) => _updateAddress(
                    formState,
                    (address) => address.copyWith(line2: value),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('AddressFormWidget.postCode'),
                        controller: _postCodeController,
                        enabled: widget.component.enabled,
                        decoration: InputDecoration(
                          labelText: translations.addressPostCodeLabel,
                          isDense: true,
                        ),
                        onChanged: (value) => _updateAddress(
                          formState,
                          (address) => address.copyWith(postCode: value),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        key: const Key('AddressFormWidget.city'),
                        controller: _cityController,
                        enabled: widget.component.enabled,
                        decoration: InputDecoration(
                          labelText: translations.addressCityLabel,
                          isDense: true,
                        ),
                        onChanged: (value) => _updateAddress(
                          formState,
                          (address) => address.copyWith(city: value),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  key: const Key('AddressFormWidget.state'),
                  controller: _stateController,
                  enabled: widget.component.enabled,
                  decoration: InputDecoration(
                    labelText: translations.addressStateLabel,
                    isDense: true,
                  ),
                  onChanged: (value) => _updateAddress(
                    formState,
                    (address) => address.copyWith(state: value),
                  ),
                ),
                const SizedBox(height: 8),
                _buildCountryField(formState, translations),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _geocodingError ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ),
                    TextButton(
                      onPressed: widget.component.enabled &&
                              _isAddressComplete &&
                              !_geocoding
                          ? () => _determinePosition(providerContext, formState)
                          : null,
                      child: Text(translations.determinePosition),
                    ),
                  ],
                ),
                if (widget.component.data.value?.geoLocation != null) ...[
                  const SizedBox(height: 8),
                  AspectRatio(
                    aspectRatio: 3 / 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: GeolocationMap(
                        location: widget.component.data.value?.geoLocation,
                        enabled: widget.component.enabled,
                        onLocationChanged: (newLocation) => _updateAddress(
                          formState,
                          (address) =>
                              address.copyWith(geoLocation: newLocation),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCountryField(
    FormFieldState<AddressDataEntity> formState,
    ApptiveGridTranslation translations,
  ) {
    final locale = Localizations.maybeLocaleOf(context)?.languageCode;
    final countryNames = locale == 'de' ? kCountryNamesDe : kCountryNamesEn;
    return TypeAheadField<String>(
      controller: _countryController,
      builder: (context, controller, focusNode) => TextField(
        key: const Key('AddressFormWidget.country'),
        controller: controller,
        focusNode: focusNode,
        enabled: widget.component.enabled,
        decoration: InputDecoration(
          labelText: translations.addressCountryLabel,
          isDense: true,
        ),
        onChanged: (value) => _updateAddress(
          formState,
          (address) => address.copyWith(country: value),
        ),
      ),
      decorationBuilder: (context, child) => Material(
        shape: Theme.of(context).cardTheme.shape,
        type: MaterialType.card,
        child: child,
      ),
      suggestionsCallback: (pattern) async {
        final query = pattern.toLowerCase();
        return countryNames
            .where((name) => name.toLowerCase().contains(query))
            .take(20)
            .toList();
      },
      itemBuilder: (_, suggestion) => ListTile(
        title: Text(suggestion),
      ),
      emptyBuilder: (_) => const SizedBox.shrink(),
      onSelected: (suggestion) {
        _countryController.text = suggestion;
        _updateAddress(
          formState,
          (address) => address.copyWith(country: suggestion),
        );
      },
    );
  }

  bool get _isAddressComplete {
    final address = widget.component.data.value;
    return (address?.line1?.isNotEmpty ?? false) &&
        (address?.city?.isNotEmpty ?? false) &&
        (address?.postCode?.isNotEmpty ?? false) &&
        (address?.country?.isNotEmpty ?? false);
  }

  String? _validate(
    ApptiveGridTranslation translations,
    AddressDataEntity? selection,
  ) {
    if (!widget.component.required) {
      return null;
    }
    final address = selection?.value;
    final missingLabels = [
      if (address?.line1?.isNotEmpty != true) translations.addressLine1Label,
      if (address?.city?.isNotEmpty != true) translations.addressCityLabel,
      if (address?.postCode?.isNotEmpty != true)
        translations.addressPostCodeLabel,
      if (address?.country?.isNotEmpty != true)
        translations.addressCountryLabel,
    ];
    if (missingLabels.isEmpty) {
      return null;
    }
    return translations.fieldIsRequired(missingLabels.join(', '));
  }

  void _updateAddress(
    FormFieldState<AddressDataEntity> formState,
    Address Function(Address address) update,
  ) {
    setState(() {
      final current = widget.component.data.value ?? const Address();
      widget.component.data.value = update(current);
    });
    formState.didChange(widget.component.data);
  }

  Future<void> _determinePosition(
    BuildContext providerContext,
    FormFieldState<AddressDataEntity> formState,
  ) async {
    final translations = ApptiveGridLocalization.of(context)!;
    setState(() {
      _geocoding = true;
      _geocodingError = null;
    });
    final address = widget.component.data.value;
    final addressString = [
      address?.line1,
      address?.line2,
      address?.postCode,
      address?.city,
      address?.state,
      address?.country,
    ].where((part) => part != null && part.isNotEmpty).join(', ');
    try {
      final locationManager =
          Provider.of<LocationManager>(providerContext, listen: false);
      final response = await locationManager.getPlaceByAddress(
        addressString,
        language: Localizations.maybeLocaleOf(context)?.languageCode,
      );
      final location = response.results.firstOrNull?.geometry.location;
      if (location != null) {
        _updateAddress(
          formState,
          (address) => address.copyWith(
            geoLocation: Geolocation(
              latitude: location.lat,
              longitude: location.lng,
            ),
          ),
        );
      } else {
        setState(() {
          _geocodingError = translations.addressGeocodingFailed;
        });
      }
    } catch (_) {
      setState(() {
        _geocodingError = translations.addressGeocodingFailed;
      });
    } finally {
      if (mounted) {
        setState(() {
          _geocoding = false;
        });
      }
    }
  }
}
