import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ruta_user/screens/busStop_screen.dart';

class BusListScreen extends StatefulWidget {
  @override
  _BusListScreenState createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  String selectedPlace = "Angamaly";

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Schedules'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: selectedPlace,
              onChanged: (newValue) {
                setState(() {
                  selectedPlace = newValue!;
                });
              },
              items: <String>["Angamaly", "Aluva", "Kakkanad"]
                  .map<DropdownMenuItem<String>>((String value) {
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
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('No buses with stop at $selectedPlace'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var bus = snapshot.data![index];
                    return ListTile(
                      title: Text(bus['name']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusStopsScreen(busId: bus.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
