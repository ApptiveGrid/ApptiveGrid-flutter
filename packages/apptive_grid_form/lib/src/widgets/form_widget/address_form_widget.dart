import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/managers/location_manager.dart';
import 'package:apptive_grid_form/src/managers/permission_manager.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/google_maps_webservice/google_maps_webservice.dart';
import 'package:apptive_grid_form/src/widgets/address/address_from_place.dart';
import 'package:apptive_grid_form/src/widgets/address/countries.dart';
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
    this.fieldProperties,
  });

  /// Component this Widget should reflect
  final FormComponent<AddressDataEntity> component;

  /// Per-field settings of the form, used for the custom
  /// [FormFieldProperties.line1Label] and [FormFieldProperties.line2Label]
  final FormFieldProperties? fieldProperties;

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

  String _line1Label(ApptiveGridTranslation translations) =>
      widget.fieldProperties?.line1Label ?? translations.addressLine1Label;

  String _line2Label(ApptiveGridTranslation translations) =>
      widget.fieldProperties?.line2Label ?? translations.addressLine2Label;

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
                _buildLine1Field(providerContext, formState, translations),
                const SizedBox(height: 8),
                TextField(
                  key: const Key('AddressFormWidget.line2'),
                  controller: _line2Controller,
                  enabled: widget.component.enabled,
                  decoration: InputDecoration(
                    labelText: _line2Label(translations),
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

  /// The first address line with Google Places suggestions
  ///
  /// Typing keeps working as a plain text field; picking a suggestion fills
  /// all fields from the place details, like the web frontend does.
  Widget _buildLine1Field(
    BuildContext providerContext,
    FormFieldState<AddressDataEntity> formState,
    ApptiveGridTranslation translations,
  ) {
    return TypeAheadField<Prediction>(
      controller: _line1Controller,
      builder: (context, controller, focusNode) => TextField(
        key: const Key('AddressFormWidget.line1'),
        controller: controller,
        focusNode: focusNode,
        enabled: widget.component.enabled,
        decoration: InputDecoration(
          labelText: _line1Label(translations),
          isDense: true,
        ),
        onChanged: (value) => _updateAddress(
          formState,
          (address) => address.copyWith(line1: value),
        ),
      ),
      decorationBuilder: (context, child) => Material(
        shape: Theme.of(context).cardTheme.shape,
        type: MaterialType.card,
        child: child,
      ),
      suggestionsCallback: (pattern) =>
          _searchAddresses(providerContext, pattern),
      itemBuilder: (_, suggestion) => ListTile(
        title: Text(suggestion.description ?? ''),
      ),
      // A street Google does not know is still a valid input, so an empty
      // result list shows nothing instead of a "no results" hint. The builder
      // is required by the API but never reached with hideOnEmpty.
      hideOnEmpty: true,
      // coverage:ignore-start
      emptyBuilder: (_) => const SizedBox.shrink(),
      // coverage:ignore-end
      onSelected: (suggestion) =>
          _applyPlace(providerContext, formState, suggestion),
    );
  }

  Future<List<Prediction>> _searchAddresses(
    BuildContext providerContext,
    String pattern,
  ) async {
    if (pattern.trim().isEmpty) {
      return [];
    }
    final locationManager =
        Provider.of<LocationManager>(providerContext, listen: false);
    // Restrict suggestions to the chosen country, like the frontend's
    // componentRestrictions. Unknown or empty country: search worldwide.
    final country = countryByName(widget.component.data.value?.country);
    try {
      final response = await locationManager.autocompleteAddress(
        pattern,
        language: Localizations.maybeLocaleOf(context)?.languageCode,
        countryCodes: [if (country != null) country.alpha2],
      );
      return response.predictions;
    } catch (_) {
      return [];
    }
  }

  Future<void> _applyPlace(
    BuildContext providerContext,
    FormFieldState<AddressDataEntity> formState,
    Prediction suggestion,
  ) async {
    final placeId = suggestion.placeId;
    if (placeId == null) {
      return;
    }
    final locationManager =
        Provider.of<LocationManager>(providerContext, listen: false);
    final PlaceDetails place;
    try {
      place = (await locationManager.getPlaceDetails(
        placeId,
        language: Localizations.maybeLocaleOf(context)?.languageCode,
        fields: const ['address_components', 'geometry', 'name', 'types'],
      ))
          .result;
    } catch (_) {
      return;
    }
    if (!mounted) {
      return;
    }
    final address = addressFromPlaceDetails(place);
    _line1Controller.text = address.line1 ?? '';
    _line2Controller.text = address.line2 ?? '';
    _cityController.text = address.city ?? '';
    _postCodeController.text = address.postCode ?? '';
    _stateController.text = address.state ?? '';
    _countryController.text = address.country ?? '';
    setState(() {
      widget.component.data.value = address;
    });
    formState.didChange(widget.component.data);
  }

  Widget _buildCountryField(
    FormFieldState<AddressDataEntity> formState,
    ApptiveGridTranslation translations,
  ) {
    final locale = Localizations.maybeLocaleOf(context)?.languageCode;
    final countryNames = [
      for (final country in kCountries) country.name(locale),
    ];
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
      // No suggestion list for a country the list does not know; the builder
      // is required by the API but never reached with hideOnEmpty.
      hideOnEmpty: true,
      // coverage:ignore-start
      emptyBuilder: (_) => const SizedBox.shrink(),
      // coverage:ignore-end
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
      if (address?.line1?.isNotEmpty != true) _line1Label(translations),
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
