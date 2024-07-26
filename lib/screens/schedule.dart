import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ruta_user/data%20fetching/get_bus_schedule.dart';
import 'package:ruta_user/models/bus_schedule.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});

  @override
  SchedulesScreenState createState() => SchedulesScreenState();
}

class SchedulesScreenState extends State<SchedulesScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<BusSchedule>>(
        stream: getBusSchedules(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final busSchedules = snapshot.data!;

          return ListView.builder(
            itemCount: busSchedules.length,
            itemBuilder: (context, index) {
              final busSchedule = busSchedules[index];

              return FutureBuilder<QuerySnapshot>(
                future: busSchedule.stops.get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ListTile(
                      title: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const ListTile(
                      title: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final stopDocs = snapshot.data!.docs;

                  return Column(
                    children: stopDocs.map<Widget>((doc) {
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: ListTile(
                          title: Text(doc['place']), // Stop name as the title
                          trailing: Text(doc['time']), // Stop time
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
