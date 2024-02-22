import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cropx/four_button.dart';
import 'package:cropx/realtimedevicedata.dart';
import 'package:cropx/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Connection extends StatefulWidget {
  const Connection({Key? key}) : super(key: key);

  @override
  State<Connection> createState() => _ConnectivityState();
}

class _ConnectivityState extends State<Connection> {
  late StreamSubscription subscription;
  late StreamSubscription internetSubscription;
  bool hasInternet = false;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen(_showConnectivitySnackbar);
    internetSubscription = InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
      if (hasInternet) {
        navigateToScreen(splashscreen());
      } else {
        navigateToScreen(MyBluetoothApp());
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    internetSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This build method won't be used since navigation happens in initState
    return Container();
  }

  void _showConnectivitySnackbar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet
        ? result == ConnectivityResult.mobile
            ? 'You are connected to Mobile network'
            : 'You are connected to WiFi network'
        : "You have no internet connection";
    final color = hasInternet ? Colors.green : Colors.red;
    _showSnackbar(context, message, color);
  }

  void navigateToScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => screen),
    );
  }

  void _showSnackbar(BuildContext context, String message, Color color) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}