import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

import 'location_manager.dart';

class GeolocationInput extends StatefulWidget {
  const GeolocationInput({
    Key? key,
    this.location,
    this.onLocationChanged,
  }) : super(key: key);

  final Geolocation? location;
  final void Function(Geolocation?)? onLocationChanged;

  @override
  geolocationInputState createState() => geolocationInputState();
}

class geolocationInputState extends State<GeolocationInput> {
  LocationManager? _locationManager;
  Geolocation? _currentTextLocation;

  final _locationBoxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.location != null) {
      _updateTextField(widget.location);
    }
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
                      language:
                          Localizations.maybeLocaleOf(context)?.languageCode))
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
        IconButton(
          onPressed: _selectCurrentLocation,
          icon: Icon(Icons.my_location),
        ),
      ],
    );
  }

  Future<void> _selectCurrentLocation() async {
    final position = await _locationManager?.getCurrentPosition();
    if (position != null) {
      final location = Geolocation(
          latitude: position.latitude, longitude: position.longitude);
      widget.onLocationChanged?.call(location);

      if (mounted) {
        _updateTextField(location);
      }
    }
  }

  Future<void> _updateTextField(Geolocation? location) async {
    if (location != null) {
      final results = (await _locationManager?.getPlaceByLocation(
        location,
        language: Localizations
            .localeOf(context)
            .languageCode,
      ))?.results;

      if (results != null && results.isNotEmpty && results.first.formattedAddress != null) {
        _locationBoxController.text = results.first.formattedAddress!;
      } else {
        _locationBoxController.text = '${location.latitude},${location.longitude}';
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
          lat: widget.location!.latitude, lng: widget.location!.longitude);
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
