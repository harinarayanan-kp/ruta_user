import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ruta_user/models/bus_schedule.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Stream<List<BusSchedule>> getBusSchedules() {
  return firestore.collection('bus_schedules').snapshots().map((querySnapshot) {
    return querySnapshot.docs
        .map((doc) => BusSchedule(
              doc['name'] as String,
              doc.reference.collection('stops'),
            ))
        .toList();
  });
}
