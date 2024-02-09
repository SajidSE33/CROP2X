import 'package:cropx/home.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class mainhome extends StatefulWidget {
  const mainhome({super.key});

  @override
  State<mainhome> createState() => _mainhomeState();
}

class _mainhomeState extends State<mainhome> {
  final nam = TextEditingController();
  // final cropingname = TextEditingController();
  final img = TextEditingController();
  final tem = TextEditingController();
  final p = TextEditingController();
  final hum = TextEditingController();
  final nit = TextEditingController();
  final wat = TextEditingController();

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child("crop");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
            body: SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            ),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.brown),
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: const Center(
                child: Text(
                  "CROP 2X",
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 70,
                  width: 300,
                  child: TextField(
                    controller: nam,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "فصل کا نام درج کریں۔",
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: 300,
                  child: TextField(
                    controller: img,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "کراپ امیج درج کریں۔",
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: 300,
                  child: TextField(
                    controller: tem,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "درجہ حرارت درج کریں۔",
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: 300,
                  child: TextField(
                    controller: p,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "PH درج کریں۔",
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: 300,
                  child: TextField(
                    controller: hum,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "نمی درج کریں۔",
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: 300,
                  child: TextField(
                    controller: nit,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "نائٹروجن کی سطح درج کریں۔",
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: 300,
                  child: TextField(
                    controller: wat,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "پانی کی مقدار درج کریں۔",
                    ),
                  ),
                ),
              ],
            ), // Repeat the same pattern for other TextFields

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                onPressed: () {
                  Map<String, String> cropdetail = {
                    "naming": nam.text,
                    // "name": cropname.text,
                    "image": img.text,
                    "temperature": tem.text,
                    "PH": p.text,
                    "humidity": hum.text,
                    "nitrogen": nit.text,
                    "waterlevel": wat.text
                  };
                  // Assuming dbRef is your database reference
                  dbRef.push().set(cropdetail);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => home()),
                  );
                },
                child: const Text(
                  "Insert Data / ڈیٹا داخل کریں۔",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(
                        width: 0.1,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  fixedSize:
                      MaterialStateProperty.all<Size>(const Size(300, 50)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.brown),
                ),
              ),
            ),
          ],
        ),
      ),
    )));
  }
}
