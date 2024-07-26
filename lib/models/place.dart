  import 'package:cloud_firestore/cloud_firestore.dart';

  class Place {
    final String placeName;
    final GeoPoint location;

    Place({required this.placeName, required this.location});

    // Function to convert Firestore document data to a Place object
    static Place fromFirestore(Map<String, dynamic> data) {
      return Place(
        placeName: data['placeName'] as String,
        location: data['location'] as GeoPoint,
      );
    }
  }