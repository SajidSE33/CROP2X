import 'package:cropx/login.dart';
import 'package:cropx/signup.dart';
import 'package:flutter/material.dart';

class secondmain extends StatefulWidget {
  const secondmain({super.key});

  @override
  State<secondmain> createState() => _secondmainState();
}

class _secondmainState extends State<secondmain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 500,
            width: 450,
            child: Image.asset(
              "images/aftersplash.png",
              // fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: Text(
                "LogIn / لاگ ان کریں ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                              width: 0.1,
                              color:
                                  const Color.fromARGB(255, 255, 255, 255)))),
                  fixedSize: MaterialStateProperty.all<Size>(Size(300, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 33, 150, 70))),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignUp()));
              },
              child: Text(
                "Create Account / اکاؤنٹ بنائیں",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 33, 150, 70)),
              ),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                              width: 1,
                              color:
                                  const Color.fromARGB(255, 33, 150, 70)))),
                  fixedSize: MaterialStateProperty.all<Size>(Size(300, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 255, 255, 255))),
            ),
          ),
        ],
      ),
    );
  }
}
