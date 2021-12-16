import 'dart:async';

import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:apptive_grid_form/managers/permission_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

/// Widget Used for handling user Input for a location
///
/// Displays the currently selected [location] as a Marker on a [GoogleMap]
/// Allows the user to select a new location by tapping a point on the Map
/// Allows the user to change the location by dragging and releasing the marker on a new Location
class GeolocationMap extends StatefulWidget {
  /// Creates a new MapWidget
  const GeolocationMap({Key? key, this.location, this.onLocationChanged})
      : super(key: key);

  /// Currently select [Geolocation]
  ///
  /// `null` if no location is set
  final Geolocation? location;

  /// Called when the User changes the Location using this Widget
  ///
  /// Called with a [Geolocation] if the user either selects a location
  /// by clicking the map or dragging the currently selected lcoation to a new place
  final void Function(Geolocation?)? onLocationChanged;

  @override
  _GeolocationMapState createState() => _GeolocationMapState();
}

class _GeolocationMapState extends State<GeolocationMap> {
  static const _zweidenkerLocation = LatLng(50.9258346, 6.937865);

  final Completer<GoogleMapController> _mapCompleter = Completer();

  bool _myLocationEnabled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<PermissionManager>(context)
        .checkPermission(Permission.locationWhenInUse)
        .then((status) {
      setState(() {
        _myLocationEnabled = status == PermissionStatus.granted;
      });
    });
  }

  @override
  void didUpdateWidget(covariant GeolocationMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.location != null && widget.location != oldWidget.location) {
      _moveToNewPosition(widget.location!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationAsLatLng = widget.location != null
        ? LatLng(widget.location!.latitude, widget.location!.longitude)
        : null;
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.location != null
            ? LatLng(widget.location!.latitude, widget.location!.longitude)
            : _zweidenkerLocation,
        zoom: 12,
      ),
      onMapCreated: (controller) {
        _mapCompleter.complete(controller);
      },
      myLocationEnabled: _myLocationEnabled,
      myLocationButtonEnabled: _myLocationEnabled,
      markers: widget.location != null
          ? {
              Marker(
                markerId: const MarkerId('currentLocationMarker'),
                position: locationAsLatLng!,
                draggable: true,
                onDragEnd: _locationSelected,
              ),
            }
          : {},
      onTap: _locationSelected,
      gestureRecognizers: {
        Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())
      },
    );
  }

  void _locationSelected(LatLng newLocation) {
    widget.onLocationChanged?.call(
      Geolocation(
        latitude: newLocation.latitude,
        longitude: newLocation.longitude,
      ),
    );
  }

  void _moveToNewPosition(Geolocation location) {
    _mapCompleter.future.then(
      (controller) => controller.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(location.latitude, location.longitude),
        ),
      ),
    );
  }
}
