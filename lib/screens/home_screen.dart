import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:ruta_user/screens/busStop_screen.dart';
import 'package:ruta_user/screens/busstop.dart';
import 'package:ruta_user/screens/map_screen.dart';
import 'package:ruta_user/screens/next_bus_screen.dart';
import 'package:ruta_user/screens/schedule.dart';
import 'package:ruta_user/screens/to_from_screen.dart';
import 'package:ruta_user/services/auth_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final bool _isLoading = false;

  static final List<Widget> _widgetOptions = <Widget>[
    const MapScreen(),
    const setRouteScreen(),
    BusListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RUTA'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        containerHeight: 75,
        curve: Curves.ease,
        selectedIndex: _selectedIndex,
        backgroundColor: colorScheme.surface,
        onItemSelected: _onItemTapped,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            activeColor: colorScheme.primary,
            icon: Container(child: Icon(Icons.map)),
            title: const Text('Map'),
          ),
          BottomNavyBarItem(
            activeColor: colorScheme.primary,
            icon: Container(
              child: Icon(Icons.sync_alt),
            ),
            title: const Text('Route'),
          ),
          BottomNavyBarItem(
            activeColor: colorScheme.primary,
            icon: Container(child: Icon(Icons.directions_bus)),
            title: const Text('Next Bus'),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  Widget _logout(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await AuthService().signout(context: context);
      },
      child: const Text("Sign Out"),
    );
  }
}
