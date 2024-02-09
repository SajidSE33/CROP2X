import 'package:cropx/login.dart';
import 'package:cropx/loginorsignup.dart';
import 'package:flutter/material.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => secondmain()));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        SizedBox(height: 100,),
        Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(300),
              border: Border.all(width: 2, color: Colors.black)),
          child: ClipOval(
            child: Image.asset(
              ("images/splash.jpg"),
              height: 350,
              width: 350,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "CROP 2X",
          style: TextStyle(
              color: Colors.green, fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ],
    )));
  }
}
