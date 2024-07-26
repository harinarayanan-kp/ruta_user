import 'package:flutter/material.dart';
import 'dart:async';

class BusRouteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _BusRouteWidget(),
    );
  }
}

class _BusRouteWidget extends StatefulWidget {
  @override
  __BusRouteWidgetState createState() => __BusRouteWidgetState();
}

class __BusRouteWidgetState extends State<_BusRouteWidget> with SingleTickerProviderStateMixin {
  final String busName = 'X';
  final List<Map<String, String>> destinations = [
    {'destination': 'Stop A', 'time': '10:00 AM'},
    {'destination': 'Stop B', 'time': '10:30 AM'},
    {'destination': 'Stop C', 'time': '11:00 AM'},
  ];
  int currentStopIndex = 0;
  late AnimationController _animationController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _startBusRouteSimulation();
  }

  void _startBusRouteSimulation() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (currentStopIndex < destinations.length - 1) {
        setState(() {
          currentStopIndex++;
        });
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Bus $busName',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == currentStopIndex ? Colors.purple[100] : Colors.white,
                              border: Border.all(color: Colors.purple[100]!, width: 2),
                            ),
                            child: Center(
                              child: Icon(
                                index == currentStopIndex ? Icons.directions_bus : Icons.circle,
                                color: index == currentStopIndex ? Colors.red : Colors.grey,
                                size: 30,
                              ),
                            ),
                          ),
                          if (index != destinations.length - 1)
                            Container(
                              height: 60,
                              width: 2,
                              color: Colors.grey,
                            ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.purple[100]!, width: 2),
                          ),
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  destination['destination']!,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  destination['time']!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }
}
