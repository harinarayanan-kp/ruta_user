import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ruta_user/screens/busStop_screen.dart';

class BusListScreen extends StatefulWidget {
  const BusListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BusListScreenState createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  String selectedPlace = "";
  List<String> places = [];

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }

  Future<void> _fetchPlaces() async {
    try {
      var locationsSnapshot =
          await FirebaseFirestore.instance.collection('locationData').get();
      var fetchedPlaces = locationsSnapshot.docs
          .map((doc) => doc['placeName'] as String)
          .toList();
      setState(() {
        places = fetchedPlaces;
        if (places.isNotEmpty) {
          selectedPlace = places.first;
        }
      });
    // ignore: empty_catches
    } catch (e) {}
  }

  Future<List<QueryDocumentSnapshot>> _getBusesWithSelectedStop() async {
    var busSchedules =
        await FirebaseFirestore.instance.collection('bus_schedules').get();
    var busesWithSelectedStop = <QueryDocumentSnapshot>[];

    for (var bus in busSchedules.docs) {
      var stops = await bus.reference.collection('stops').get();
      if (stops.docs.any((stop) => stop['place'] == selectedPlace)) {
        busesWithSelectedStop.add(bus);
      }
    }

    return busesWithSelectedStop;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // _logout(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: places.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButton<String>(
                      value: selectedPlace,
                      onChanged: (newValue) {
                        setState(() {
                          selectedPlace = newValue!;
                        });
                      },
                      items:
                          places.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
            ),
            Expanded(
              child: FutureBuilder<List<QueryDocumentSnapshot>>(
                future: _getBusesWithSelectedStop(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('No buses with stop at $selectedPlace'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var bus = snapshot.data![index];
                      return Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          leading:
                              const Icon(Icons.directions_bus, color: Colors.blue),
                          title: Text(bus['name']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BusStopsScreen(busId: bus.id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
