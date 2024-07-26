import 'package:flutter/material.dart';


class BusTimingScreen extends StatefulWidget {
  @override
  _BusTimingScreenState createState() => _BusTimingScreenState();
}

class _BusTimingScreenState extends State<BusTimingScreen> {
  String? selectedBus;
  String? startStop;
  String? endStop;
  String? travelTime;

  final List<Map<String, dynamic>> busRoutes = [
    {
      'busNumber': '101',
      'stops': [
        {'name': 'Stop A', 'arrivalTime': '08:00'},
        {'name': 'Stop B', 'arrivalTime': '08:15'},
        {'name': 'Stop C', 'arrivalTime': '08:30'},
        {'name': 'Stop D', 'arrivalTime': '08:45'},
        {'name': 'Stop E', 'arrivalTime': '09:00'},
      ]
    },
    {
      'busNumber': '102',
      'stops': [
        {'name': 'Stop X', 'arrivalTime': '09:00'},
        {'name': 'Stop Y', 'arrivalTime': '09:20'},
        {'name': 'Stop Z', 'arrivalTime': '09:40'},
      ]
    },
    // Add more bus routes as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Bus Timing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            DropdownButton<String>(
              hint: Text('Select Bus'),
              value: selectedBus,
              onChanged: (value) {
                setState(() {
                  selectedBus = value;
                  startStop = null;
                  endStop = null;
                  travelTime = null;
                });
              },
              items: busRoutes.map((route) {
                return DropdownMenuItem<String>(
                  value: route['busNumber'],
                  child: Text('Bus ${route['busNumber']}'),
                );
              }).toList(),
            ),
            if (selectedBus != null) ...[
              DropdownButton<String>(
                hint: Text('Select Start Stop'),
                value: startStop,
                onChanged: (value) {
                  setState(() {
                    startStop = value;
                    endStop = null;
                    travelTime = null;
                  });
                },
                items: getStopsForSelectedBus()
                    .map((stop) {
                      return DropdownMenuItem<String>(
                        value: stop['name'],
                        child: Text(stop['name']!),
                      );
                    })
                    .toList(),
              ),
              DropdownButton<String>(
                hint: Text('Select End Stop'),
                value: endStop,
                onChanged: (value) {
                  setState(() {
                    endStop = value;
                    calculateTravelTime();
                  });
                },
                items: getStopsForSelectedBus()
                    .map((stop) {
                      return DropdownMenuItem<String>(
                        value: stop['name'],
                        child: Text(stop['name']!),
                      );
                    })
                    .toList(),
              ),
            ],
            if (travelTime != null) ...[
              SizedBox(height: 20),
              Text(
                'Travel Time: $travelTime',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> getStopsForSelectedBus() {
    final busRoute = busRoutes.firstWhere((route) => route['busNumber'] == selectedBus);
    return List<Map<String, String>>.from(busRoute['stops']);
  }

  void calculateTravelTime() {
    final busRoute = busRoutes.firstWhere((route) => route['busNumber'] == selectedBus);
    final start = busRoute['stops'].firstWhere((stop) => stop['name'] == startStop);
    final end = busRoute['stops'].firstWhere((stop) => stop['name'] == endStop);

    final startTime = TimeOfDay(
      hour: int.parse(start['arrivalTime'].split(':')[0]),
      minute: int.parse(start['arrivalTime'].split(':')[1]),
    );

    final endTime = TimeOfDay(
      hour: int.parse(end['arrivalTime'].split(':')[0]),
      minute: int.parse(end['arrivalTime'].split(':')[1]),
    );

    final duration = Duration(
      hours: endTime.hour - startTime.hour,
      minutes: endTime.minute - startTime.minute,
    );

    setState(() {
      travelTime = '${duration.inHours}h ${duration.inMinutes % 60}m';
    });
  }
}