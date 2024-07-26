import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ruta_user/models/place.dart';
import 'package:ruta_user/screens/schedule.dart';

// ignore: camel_case_types
class setRouteScreen extends StatefulWidget {
  const setRouteScreen({super.key});

  @override
  State<setRouteScreen> createState() => _setRouteScreenState();
}

// ignore: camel_case_types
class _setRouteScreenState extends State<setRouteScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _fromFocusNode = FocusNode();
  final _toFocusNode = FocusNode();
  List<String> _allPlaceNames = [];
  List<String> _filteredFromPlaceNames = [];
  List<String> _filteredToPlaceNames = [];

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
    setState(() {});
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
      });
    } catch (e) {
      setState(() {});
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
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _fromController,
                        focusNode: _fromFocusNode,
                        decoration: const InputDecoration(
                          labelText: 'From',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => _filterPlaceNames(value, true),
                      ),
                    ),
                    const SizedBox(width: 16), // Spacer between the fields
                    Expanded(
                      child: TextFormField(
                        controller: _toController,
                        focusNode: _toFocusNode,
                        decoration: const InputDecoration(
                          labelText: 'To',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => _filterPlaceNames(value, false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Display filtered place names as dropdown suggestions
                if (_filteredFromPlaceNames.isNotEmpty)
                  _buildDropdownSuggestions(
                    _fromController,
                    _filteredFromPlaceNames,
                    (placeName) => _handleSelection(placeName, _fromController),
                  ),
                const SizedBox(height: 20),
                if (_filteredToPlaceNames.isNotEmpty)
                  _buildDropdownSuggestions(
                    _toController,
                    _filteredToPlaceNames,
                    (placeName) => _handleSelection(placeName, _toController),
                  ),

                // Submit button
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text("Submit"),
                ),

                const SizedBox(height: 30),
                const SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: SizedBox(height: 500, child: SchedulesScreen())),
                const Text('HY')
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownSuggestions(
    TextEditingController controller,
    List<String> suggestions,
    void Function(String) onSelect,
  ) {
    final limitedSuggestions = suggestions.take(3).toList();

    return Visibility(
      visible: controller.text.isNotEmpty,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: ListView(
          shrinkWrap: true,
          children: limitedSuggestions
              .map((placeName) => ListTile(
                    title: Text(placeName),
                    onTap: () {
                      onSelect(placeName);
                      FocusScope.of(context).unfocus();
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
