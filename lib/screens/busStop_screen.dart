import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusStopsScreen extends StatelessWidget {
  final String busId;

  const BusStopsScreen({super.key, required this.busId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Stops'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('bus_schedules').doc(busId).collection('stops').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No stops available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var stop = snapshot.data!.docs[index];
              return ListTile(
                title: Text(stop['place']),
                subtitle: Text(stop['time']),
              );
            },
          );
        },
      ),
    );
  }
}
