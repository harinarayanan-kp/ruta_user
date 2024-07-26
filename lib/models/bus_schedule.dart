import 'package:cloud_firestore/cloud_firestore.dart';

class BusSchedule {
  final String name;
  final CollectionReference stops;

  BusSchedule(this.name, this.stops);

  get stopsData => null;
}
