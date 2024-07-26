import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ruta_user/data%20fetching/get_current_location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  CameraPosition? _cameraPosition;
  bool _isLoading = true;
  bool _locationError = false;
  late StreamSubscription<Position> _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _checkLocationServices();
    _startLocationServiceListener();
  }

  Future<void> _checkLocationServices() async {
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
        _locationError = true;
      });
      return;
    }

    _setCurrentLocation();
  }

  Future<void> _setCurrentLocation() async {
    try {
      Position position = await getCurrentLocation();
      setState(() {
        _cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18,
        );
        _isLoading = false;
        _locationError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _locationError = true;
      });
    }
  }

  void _startLocationServiceListener() {
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      if (_locationError) {
        _checkLocationServices();
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_cameraPosition != null) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(_cameraPosition!),
      );
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 500,
          width: 500,
          child: Stack(
            children: [
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (_locationError)
                const Center(
                  child: Text(
                    'Location services are disabled. Please enable them.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              if (!_isLoading && !_locationError)
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: _cameraPosition!,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
