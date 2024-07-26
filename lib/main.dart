import 'package:flutter/material.dart';
import 'package:ruta_user/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ruta_user/screens/home_screen.dart';
import 'package:ruta_user/screens/login_screen.dart';
import 'package:ruta_user/screens/reg_screen.dart';
import 'package:ruta_user/screens/to_from_screen.dart';
import 'package:ruta_user/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Wrapper(),
      routes: {
        '/login': (context) => Login(),
        '/home': (context) => const HomeScreen(),
        '/register': (context) => Signup(),
        // '/schedule': (context) => const SchedulesScreen(),
      },
    );
  }
}
