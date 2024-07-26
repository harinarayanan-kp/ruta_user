import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:ruta_user/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ruta_user/screens/busview.dart';
import 'package:ruta_user/screens/home_screen.dart';
import 'package:ruta_user/screens/login_screen.dart';
import 'package:ruta_user/screens/reg_screen.dart';
import 'package:ruta_user/screens/signout_screen.dart';
import 'package:ruta_user/screens/to_from_screen.dart';
import 'package:ruta_user/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

Color defaultcolorscheme = const Color.fromARGB(255, 236, 174, 44);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightdynamic, ColorScheme? dark) {
      ColorScheme lightcolorscheme;
      ColorScheme darkcolorscheme;
      if (lightdynamic != null && dark != null) {
        lightcolorscheme = lightdynamic.harmonized()..copyWith();
        lightcolorscheme =
            lightcolorscheme.copyWith(secondary: defaultcolorscheme);
        darkcolorscheme = dark.harmonized();
      } else {
        lightcolorscheme = ColorScheme.fromSeed(seedColor: defaultcolorscheme);
      }
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: lightcolorscheme,
            useMaterial3: true,
            scaffoldBackgroundColor: lightcolorscheme.surfaceBright),
        home: const Wrapper(),
        routes: {
          '/login': (context) => Login(),
          '/home': (context) => const HomeScreen(),
          '/register': (context) => Signup(),
          '/route': (context) => const setRouteScreen(),
          '/settings': (context) => WidgetScreen(),
          '/driver': (context) => const BusMapScreen(),
        },
      );
    });
  }
}
