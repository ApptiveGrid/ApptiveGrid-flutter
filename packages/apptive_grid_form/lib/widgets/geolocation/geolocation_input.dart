import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/managers/location_manager.dart';
import 'package:apptive_grid_form/managers/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

/// Widget Used for handling user Input for a location
///
/// Gives users the ability to search for a Location by Text
/// Also gives the user the ability to set the current location as the desired location
class GeolocationInput extends StatefulWidget {
  /// Creates the Input Widget
  const GeolocationInput({
    Key? key,
    this.location,
    this.onLocationChanged,
  }) : super(key: key);

  /// Currently select [Geolocation]
  ///
  /// `null` if no location is set
  final Geolocation? location;

  /// Called when the User changes the Location using this Widget
  ///
  /// Called with a [Geolocation] if the user either selects a location from search or to the user's current location
  ///
  /// Called with `null` if the user clears the currently selected Location
  final void Function(Geolocation?)? onLocationChanged;

  @override
  _GeolocationInputState createState() => _GeolocationInputState();
}

class _GeolocationInputState extends State<GeolocationInput> {
  LocationManager? _locationManager;
  Geolocation? _currentTextLocation;

  PermissionStatus? _myLocationPermission;

  final _locationBoxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.location != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _updateTextField(widget.location);
      });
    }
    _locationBoxController.addListener(() {
      if (_locationBoxController.text.isEmpty && widget.location != null) {
        _updateTextField(null);
        widget.onLocationChanged?.call(null);
      }
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _locationManager = Provider.of<LocationManager>(context);
  }

  @override
  void didUpdateWidget(covariant GeolocationInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.location != _currentTextLocation) {
      _updateTextField(widget.location);
    }
  }

  @override
  void dispose() {
    _locationBoxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translations = ApptiveGridLocalization.of(context)!;
    return Row(
      children: [
        Expanded(
          child: TypeAheadField<Prediction>(
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              shape: Theme.of(context).cardTheme.shape,
            ),
            textFieldConfiguration: TextFieldConfiguration(
              controller: _locationBoxController,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).textTheme.headline1!.color,
                ),
                suffixIcon: _locationBoxController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _locationBoxController.clear();
                        },
                        icon: const Icon(Icons.clear),
                        iconSize: 16,
                      ),
                hintText: translations.searchLocation,
              ),
            ),
            suggestionsCallback: _getQueryProposals,
            itemBuilder: (_, suggestion) {
              return ListTile(
                title: Text(suggestion.description ?? ''),
              );
            },
            noItemsFoundBuilder: (_) {
              return ListTile(title: Text(translations.searchLocationNoResult));
            },
            onSuggestionSelected: (suggestion) async {
              if (suggestion.description != null) {
                _locationBoxController.text = suggestion.description!;
              }

              final placeLocation = (await _locationManager?.getPlaceDetails(
                suggestion.placeId!,
                language: Localizations.maybeLocaleOf(context)?.languageCode,
              ))
                  ?.result
                  .geometry
                  ?.location;
              if (placeLocation != null) {
                final location = Geolocation(
                  latitude: placeLocation.lat,
                  longitude: placeLocation.lng,
                );
                _currentTextLocation = location;
                widget.onLocationChanged?.call(location);
              }
            },
          ),
        ),
        if (_myLocationPermission != PermissionStatus.permanentlyDenied)
          IconButton(
            onPressed: _selectCurrentLocation,
            icon: const Icon(Icons.my_location),
          ),
      ],
    );
  }

  void _selectCurrentLocation() {
    Provider.of<PermissionManager>(context, listen: false)
        .requestPermission(Permission.locationWhenInUse)
        .then((status) async {
      if (status == PermissionStatus.granted) {
        final position = await _locationManager?.getCurrentPosition();
        if (position != null) {
          final location = Geolocation(
            latitude: position.latitude,
            longitude: position.longitude,
          );
          widget.onLocationChanged?.call(location);

          if (mounted) {
            _updateTextField(location);
          }
        }
      }
      if (mounted) {
        setState(() {
          _myLocationPermission = status;
        });
      }
    });
  }

  Future<void> _updateTextField(Geolocation? location) async {
    if (location != null) {
      final results = (await _locationManager?.getPlaceByLocation(
        location,
        language: Localizations.localeOf(context).languageCode,
      ))
          ?.results;

      if (results != null &&
          results.isNotEmpty &&
          results.first.formattedAddress != null) {
        _locationBoxController.text = results.first.formattedAddress!;
      } else {
        _locationBoxController.text =
            '${location.latitude}, ${location.longitude}';
      }
    } else {
      _locationBoxController.clear();
    }
    _currentTextLocation = location;
  }

  Future<List<Prediction>> _getQueryProposals(String query) async {
    Location? location;
    if (widget.location != null) {
      location = Location(
        lat: widget.location!.latitude,
        lng: widget.location!.longitude,
      );
    }
    final language = Localizations.localeOf(context).languageCode;
    final response = await _locationManager?.queryAutocomplete(
      query,
      location: location,
      language: language,
    );
    return response?.predictions ?? [];
  }
}
