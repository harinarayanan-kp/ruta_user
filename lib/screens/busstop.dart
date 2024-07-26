import 'package:flutter/material.dart';

// Define the Bus class
class Bus {
  final String busNumber;
  final String destination;
  final String estimatedArrival;

  Bus({
    required this.busNumber,
    required this.destination,
    required this.estimatedArrival,
  });
}

// Define the BusStop class
class BusStop {
  final String name;
  final List<Bus> buses;

  BusStop({
    required this.name,
    required this.buses,
  });
}

// Sample data for demonstration
final List<BusStop> busStops = [
  BusStop(
    name: 'Downtown',
    buses: [
      Bus(busNumber: '42', destination: 'Uptown', estimatedArrival: '5 mins'),
      Bus(busNumber: '10', destination: 'Midtown', estimatedArrival: '15 mins'),
    ],
  ),
  BusStop(
    name: 'Uptown',
    buses: [
      Bus(
          busNumber: '42',
          destination: 'Downtown',
          estimatedArrival: '10 mins'),
      Bus(
          busNumber: '20',
          destination: 'Northside',
          estimatedArrival: '7 mins'),
    ],
  ),
  // Add more bus stops and buses here if needed
];

class BusstopApp extends StatefulWidget {
  @override
  _BusstopAppState createState() => _BusstopAppState();
}

class _BusstopAppState extends State<BusstopApp> {
  BusStop? _selectedBusStop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Stop Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown Menu
            DropdownButton<BusStop>(
              hint: const Text('Select a bus stop'),
              value: _selectedBusStop,
              onChanged: (BusStop? newValue) {
                setState(() {
                  _selectedBusStop = newValue;
                });
              },
              items: busStops.map((BusStop busStop) {
                return DropdownMenuItem<BusStop>(
                  value: busStop,
                  child: Text(busStop.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            // Display Bus Details
            Expanded(
              child: _selectedBusStop == null
                  ? const Center(
                      child: Text('Select a bus stop to see details'))
                  : ListView.builder(
                      itemCount: _selectedBusStop!.buses.length,
                      itemBuilder: (context, index) {
                        final bus = _selectedBusStop!.buses[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4.0,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            title: Text('Bus Number: ${bus.busNumber}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Destination: ${bus.destination}'),
                                Text(
                                    'Estimated Arrival: ${bus.estimatedArrival}'),
                              ],
                            ),
                          ),
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

void main() {
  runApp(MaterialApp(
    home: BusstopApp(),
  ));
}
