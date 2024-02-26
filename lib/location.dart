import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String latitude = '';
  String longitude = '';
  String currentDate = '';
  String currentTime = '';
  StreamSubscription<Position>? _positionStreamSubscription;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _listenForLocationChanges();
    _updateDateTime(); // Initial update
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _updateDateTime(); // Update every second
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _timer.cancel();
    super.dispose();
  }

  void _listenForLocationChanges() {
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      });
    });
  }

  void _updateDateTime() {
    DateTime now = DateTime.now();
    setState(() {
      currentDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geolocator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Latitude: $latitude',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'Longitude: $longitude',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Current Date: $currentDate',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'Current Time: $currentTime',
              style: TextStyle(fontSize: 20.0),
            ),
            // Other content on your page
          ],
        ),
      ),
    );
  }
}
