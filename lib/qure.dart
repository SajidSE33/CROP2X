// ignore_for_file: camel_case_types, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
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

    // Ensure that the values are not empty
    if (issuecontroller.text.isEmpty ||
        descriptioncontroller.text.isEmpty ||
        feedbackcontroller.text.isEmpty) {
      print("Please fill in all fields");
      return;
    }

    try {
      await clients.add({
        'issue': issuecontroller.text,
        'descript': descriptioncontroller.text,
        'feedback': feedbackcontroller.text,
      });

      // Clear text controllers after successful submission
      issuecontroller.text = "";
      descriptioncontroller.text = "";
      feedbackcontroller.text = "";

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback form submitted")),
      );
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor based project'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.red,
      body: Container(
          margin: EdgeInsets.only(left: 2),
          child: Column(children: [
            SizedBox(height: 10),
            const Text(
              'Feedback Form',
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 24),
            ),
            // ElevatedButton(onPressed: () async{
            //
            //   if(result==null){
            //     print("result");
            //
            //   }else{
            //     print("error");
            //   }
            // }, child: Text('submit')),
            //
            SizedBox(height: 15),
            Text(
              "1) Do you have any issues?",
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 15),
            ),

            SizedBox(height: 3),
            TextField(
              controller: issuecontroller,
              obscureText: false,
              decoration: const InputDecoration(
                  hintText: "yes/no",
                  hoverColor: Colors.blueGrey,
                  prefixIcon: Icon(Icons.report_problem_outlined),
                  prefixIconColor: Colors.black),
            ),
            SizedBox(height: 3),
            Text(
              "2) Description Of queries?",
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 15),
            ),
            SizedBox(height: 3),
            TextField(
              controller: descriptioncontroller,
              obscureText: false,
              decoration: const InputDecoration(
                  hintText: "description ",
                  hintMaxLines: 3,
                  prefixIcon: Icon(Icons.question_answer_outlined),
                  prefixIconColor: Colors.black),
            ),
            SizedBox(height: 3),
            Text(
              "3) Give any solution or feedback?",
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 15),
            ),
            SizedBox(height: 3),
            TextField(
              controller: feedbackcontroller,
              obscureText: false,
              decoration: const InputDecoration(
                  hintText: "feedback",
                  hintMaxLines: 3,
                  prefixIcon: Icon(Icons.info),
                  prefixIconColor: Colors.black),
            ),
            Container(
              margin: EdgeInsets.only(left: 2),
              height: 40,
              width: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23), color: Colors.blue),
              child: ElevatedButton(
                // shape:RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(20),

                onPressed: () {
                  submit();
                },
                child: Text("Submit"),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => authentication()));
                },
                child: Text("Back"))
            // splashColor: Colors.p
          ])),
    );
  }
}

class mycollection {
  static var farmer = "farmer";
}
