import 'package:flutter/material.dart';

class location extends StatefulWidget {
  const location({super.key});

  @override
  State<location> createState() => _locationState();
}

class _locationState extends State<location> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "کسان کا موجودہ مقام",
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 33, 150, 70),
      ),
    );
  }
}
