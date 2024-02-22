import 'dart:convert';
import 'dart:io';
import 'package:cropx/login.dart';
import 'package:cropx/loginorsignup.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  List receivedDataList = [];
  void adddata() async {
    print("\n");
    print("\n");
    print("\n");
    print("\n");
    print("\n");
    print("Txt Content    ${readCounter(context)}");
    for (var i = 0; i < receivedDataList.length; i++) {
      var realdata = FirebaseFirestore.instance.collection(data.datalist);
      try {
        if (receivedDataList[i]["id"] == null) {
        } else {
          await realdata.add({
            "id": receivedDataList[i]["id"],
            "c": receivedDataList[i]["c"],
            "k": receivedDataList[i]["k"],
            "m": receivedDataList[i]["m"],
            "n": receivedDataList[i]["n"],
            "p": receivedDataList[i]["p"],
            "pH": receivedDataList[i]["pH"],
            "t": receivedDataList[i]["t"],
          });
        }
      } catch (e) {
        print("Sajid nahi howa ha add kuch kar ${e}");
      }
    }
    await (await _localFile).writeAsString('');
    receivedDataList.clear();
    print("\n");
    print("\n");
    print("\n");
    print("\n");
    print("\n");
    print("Txt Content    ${readCounter(context)}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () async {
      receivedDataList = await readCounter(context);
      adddata();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => secondmain()));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        SizedBox(
          height: 100,
        ),
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
              color: Color.fromARGB(255, 33, 150, 70),
              fontSize: 40,
              fontWeight: FontWeight.bold),
        ),
      ],
    )));
  }
}

class data {
  static String datalist = "realtimedata";
}

Map<String, dynamic> parseStringToMap(String line) {
  try {
    // Preprocess the line to convert it into valid JSON
    line =
        line.replaceAll('{', '{"').replaceAll(':', '":').replaceAll(', ', ',"');

    // Use json.decode to convert the string to a map
    return json.decode(line);
  } catch (e) {
    // Handle parsing error
    print('Error parsing line: $e');
    return {};
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/data.txt');
}

Future<List<Map<String, dynamic>>> readCounter(BuildContext context) async {
  try {
    final file = await _localFile;

    // Read content from the file
    String content = await file.readAsString();

    // Split the content into lines
    List<String> lines = content.split('\n');

    // List to store maps
    List<Map<String, dynamic>> mapsList = [];

    // Parse each line into a map
    for (String line in lines) {
      try {
        // Replace this with your actual method to parse a string into a map
        Map<String, dynamic> map = parseStringToMap(line);

        // Add the map to the list
        mapsList.add(map);
      } catch (e) {
        print('Error parsing line: $e');
      }
    }
    return mapsList;
  } catch (e) {
    return [];
  }
}
