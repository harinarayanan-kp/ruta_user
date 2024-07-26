import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ruta_user/data%20fetching/get_current_location.dart';
import 'package:ruta_user/services/auth_services.dart';

class BusMapScreen extends StatefulWidget {
  const BusMapScreen({super.key});

  @override
  State<BusMapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<BusMapScreen> {
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await AuthService().signout(context: context);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
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
                      gestureRecognizers: <Factory<
                          OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Theme.of(context).primaryColorDark),
                      child: Center(
                        child: Text(
                          'data',
                          selectionColor: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
