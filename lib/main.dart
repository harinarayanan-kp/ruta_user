import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:ruta_user/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ruta_user/screens/home_screen.dart';
import 'package:ruta_user/screens/login_screen.dart';
import 'package:ruta_user/screens/reg_screen.dart';
import 'package:ruta_user/screens/to_from_screen.dart';
import 'package:ruta_user/wrapper.dart';
import 'package:material_color_utilities/dynamiccolor/dynamic_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

Color defaultcolorscheme = Color.fromARGB(255, 236, 174, 44);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? dark) {
      ColorScheme LightColorScheme;
      ColorScheme darkColorScheme;

      if (lightDynamic != null && dark != null) {
        LightColorScheme = lightDynamic.harmonized()..copyWith();
        LightColorScheme =
            LightColorScheme.copyWith(secondary: defaultcolorscheme);
        darkColorScheme = dark.harmonized();
      } else {
        LightColorScheme = ColorScheme.fromSeed(seedColor: defaultcolorscheme);
        darkColorScheme = ColorScheme.fromSeed(
            seedColor: defaultcolorscheme, brightness: Brightness.dark);
      }
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(useMaterial3: true, colorScheme: LightColorScheme),
        home: const HomeScreen(),
        routes: {
          '/login': (context) => Login(),
          '/home': (context) => const HomeScreen(),
          '/register': (context) => Signup(),
          '/route': (context) => const setRouteScreen(),
        },
      );
    });
  }
}
