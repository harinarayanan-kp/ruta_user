import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ruta_user/models/place.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Stream<List<Place>> getAllPlaces() {
  return firestore.collection('locationData').snapshots().map((querySnapshot) {
    return querySnapshot.docs
        .map((doc) => Place.fromFirestore(doc.data()))
        .toList();
  });
}

Future<List<Place>> searchPlacesByName(String searchTerm) async {
  if (searchTerm.isEmpty) return [];
  final querySnapshot = await firestore
      .collection('locationData')
      .where('placeName', isGreaterThanOrEqualTo: searchTerm.toLowerCase())
      .where('placeName',
          isLessThanOrEqualTo: '${searchTerm.toLowerCase()}\uf8ff')
      .get();

  return querySnapshot.docs
      .map((doc) => Place.fromFirestore(doc.data()))
      .toList();
}
