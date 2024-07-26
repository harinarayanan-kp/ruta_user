import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ruta_user/models/place.dart';
import 'package:ruta_user/screens/map_screen.dart';
import 'package:ruta_user/services/auth_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _fromFocusNode = FocusNode();
  final _toFocusNode = FocusNode();
  List<String> _allPlaceNames = [];
  List<String> _filteredFromPlaceNames = [];
  List<String> _filteredToPlaceNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlaceNames();
    _fromFocusNode.addListener(() {
      if (!_fromFocusNode.hasFocus) {
        setState(() {
          _filteredFromPlaceNames = [];
        });
      }
    });
    _toFocusNode.addListener(() {
      if (!_toFocusNode.hasFocus) {
        setState(() {
          _filteredToPlaceNames = [];
        });
      }
    });
  }

  Future<void> _fetchPlaceNames() async {
    setState(() {
      _isLoading = true;
    });
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('locationData').get();
      final placeNames = snapshot.docs
          .map((doc) =>
              Place.fromFirestore(doc.data() as Map<String, dynamic>).placeName)
          .toList();
      setState(() {
        _allPlaceNames = placeNames;
        _filteredFromPlaceNames = placeNames;
        _filteredToPlaceNames = placeNames;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterPlaceNames(String query, bool isFrom) {
    setState(() {
      if (isFrom) {
        _filteredFromPlaceNames = _allPlaceNames
            .where((placeName) =>
                placeName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        _filteredToPlaceNames = _allPlaceNames
            .where((placeName) =>
                placeName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _handleSelection(String placeName, TextEditingController controller) {
    setState(() {
      controller.text = placeName;
      _filteredFromPlaceNames = _allPlaceNames;
      _filteredToPlaceNames = _allPlaceNames;
    });
    FocusScope.of(context).unfocus();
  }

  void _submit() {
    final fromPlace = _fromController.text;
    final toPlace = _toController.text;
    if (fromPlace.isNotEmpty && toPlace.isNotEmpty) {
      // Navigate to the schedules screen
      Navigator.pushNamed(context, '/schedule');
    } else {
      // Handle case where one or both fields are empty
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Hello👋',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),

                Text(
                  FirebaseAuth.instance.currentUser?.email ?? 'No user',
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(height: 16),
                // Show loading spinner if _isLoading is true
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (!_isLoading) const MapScreen(),
                const SizedBox(height: 30),

                

                const SizedBox(height: 30),
                _logout(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logout(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await AuthService().signout(context: context);
      },
      child: const Text("Sign Out"),
    );
  }
}
