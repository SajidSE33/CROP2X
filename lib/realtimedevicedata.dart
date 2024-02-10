import 'package:flutter/material.dart';

class real extends StatefulWidget {
  const real({super.key});

  @override
  State<real> createState() => _realState();
}

class _realState extends State<real> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ریئل ٹائم فصل کی تفصیل",
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
