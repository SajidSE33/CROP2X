// ignore_for_file: prefer_const_constructors

import 'package:cropx/add_data.dart';
import 'package:cropx/showall.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                height: 620,
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      "CROP 2X",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 40,
                        ),
                        ClipOval(
                          child: Image.asset(
                            ("images/crop1.jpg"),
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        ClipOval(
                          child: Image.asset(
                            ("images/crop2.jpg"),
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 40,
                        ),
                        ClipOval(
                          child: Image.asset(
                            ("images/crop3.jpg"),
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        ClipOval(
                          child: Image.asset(
                            ("images/crop4.jpg"),
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: const [
                          Text(
                            "یہ ایپلیکیشن رہنمائی فراہم کرتی ہے۔",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "مناسب خاکہ زیادہ سے زیادہ",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "کامیاب ہونے کے لئے شرائط",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "پودوں کی ترقی.",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => showalldata()),
                    );
                  },
                  child: Text(
                    "Show All Crops / تمام فصلیں دکھائیں۔",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          width: 0.1,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                    fixedSize: MaterialStateProperty.all<Size>(Size(350, 50)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 33, 150, 70),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => mainhome()),
                    );
                  },
                  child: Text(
                    "Add Crops / فصلیں شامل کریں۔",
                    style: TextStyle(
                      color: Color.fromARGB(255, 33, 150, 70),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          width: 1,
                          color: const Color.fromARGB(255, 33, 150, 70),
                        ),
                      ),
                    ),
                    fixedSize: MaterialStateProperty.all<Size>(Size(350, 50)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
