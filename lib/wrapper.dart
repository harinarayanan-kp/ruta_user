import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firestore
import 'package:flutter/material.dart';
import 'package:ruta_user/screens/busview.dart';
import 'package:ruta_user/screens/home_screen.dart';
import 'package:ruta_user/screens/login_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        } else {
          if (snapshot.data == null) {
            return Login();
          } else {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (roleSnapshot.hasError) {
                  return const Center(
                    child: Text('Error'),
                  );
                } else {
                  if (roleSnapshot.hasData) {
                    final userRole = roleSnapshot.data!['role'];
                    if (userRole == 'driver') {
                      return const BusMapScreen();
                    } else {
                      return const HomeScreen();
                    }
                  } else {
                    return Login();
                  }
                }
              },
            );
          }
        }
      },
    );
  }
}
