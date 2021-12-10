import 'dart:async';

import 'package:apptive_grid_core/apptive_grid_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeolocationMap extends StatefulWidget {
  const GeolocationMap({Key? key, this.location, this.onLocationChanged})
      : super(key: key);

  final Geolocation? location;
  final void Function(Geolocation?)? onLocationChanged;

  @override
  _GeolocationMapState createState() => _GeolocationMapState();
}

class _GeolocationMapState extends State<GeolocationMap> {
  static const _zweidenkerLocation = LatLng(50.9258346, 6.937865);

  final Completer<GoogleMapController> _mapCompleter = Completer();

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
      myLocationEnabled: true,
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
