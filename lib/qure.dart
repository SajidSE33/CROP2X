// ignore_for_file: camel_case_types, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cropx/four_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class authentication extends StatefulWidget {
  const authentication({super.key});

  @override
  State<authentication> createState() => _authenticationState();
}

class _authenticationState extends State<authentication> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _initializeFirebase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return query();
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}

class query extends StatefulWidget {
  const query({super.key});

  @override
  State<query> createState() => _queryState();
}

class _queryState extends State<query> {
  TextEditingController issuecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController feedbackcontroller = TextEditingController();
  submit() async {
    var clients = FirebaseFirestore.instance.collection(mycollection.farmer);
    if (issuecontroller.text.isEmpty ||
        descriptioncontroller.text.isEmpty ||
        feedbackcontroller.text.isEmpty) {
      print("Fill all data");
      return;
    }

    try {
      await clients.add({
        'issue': issuecontroller.text,
        'description': descriptioncontroller.text,
        'feedback': feedbackcontroller.text,
      });
      issuecontroller.text = "";
      descriptioncontroller.text = "";
      feedbackcontroller.text = "";

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("فیڈ بیک فارم جمع کرایا گیا۔")),
      );
    } catch (error) {
      print("Error$error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "فیڈ بیک فارم",
            style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 0, 128, 6),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
              margin: EdgeInsets.only(left: 2),
              child: Column(children: [
                SizedBox(height: 80),
                Text(
                  "کیا آپ کو کوئی مسئلہ ہے؟",
                  style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 15),
                ),
                SizedBox(height: 3),
                Container(
                  height: 70,
                  width: 300,
                  child: TextField(
                    controller: issuecontroller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "ہاں/نہیں",
                    ),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "سوالات کی تفصیل؟",
                  style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 15),
                ),
                SizedBox(height: 3),
                Container(
                  height: 70,
                  width: 300,
                  child: TextField(
                    controller: descriptioncontroller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "تفصیل",
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "کوئی حل یا رائے دیں؟",
                  style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 15),
                ),
                SizedBox(height: 10),
                Container(
                  height: 70,
                  width: 300,
                  child: TextField(
                    controller: feedbackcontroller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "رائے",
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      submit();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => fourbutton()),
                      );
                    },
                    child: Text(
                      "جمع کرائیں",
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
                      fixedSize: MaterialStateProperty.all<Size>(Size(300, 50)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 0, 128, 6),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // splashColor: Colors.p
              ])),
        ),
      ),
    );
  }
}

class mycollection {
  static var farmer = "farmer";
}
