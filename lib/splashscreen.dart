import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cropx/four_button.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
List<Map<String, String>> receivedDataList = [];
  void adddata() async {
    print("sajid dakh abhi ${receivedDataList}");
    print("\n");
    print("\n");
    print("\n");
    print("\n");
    print("\n");
    for (var i = 0; i < receivedDataList.length; i++) {
      var realdata = FirebaseFirestore.instance.collection(data.datalist);
      try {
        if (receivedDataList[i]["id"] == null) {
        } else {
          String? date = receivedDataList[i]["date"];
          String? time = receivedDataList[i]["time"];
          time = time?.replaceAll('-', ':');
          String doc1 = "$date-$time";
          await realdata.doc(doc1).set({
            "id": receivedDataList[i]["id"],
            "conductivity": receivedDataList[i]["c"],
            "potassium": receivedDataList[i]["k"],
            "moisture": receivedDataList[i]["m"],
            "nitrogen": receivedDataList[i]["n"],
            "phosphor": receivedDataList[i]["p"],
            "pH": receivedDataList[i]["pH"],
            "temperature": receivedDataList[i]["t"],
            "longitude": receivedDataList[i]["longitude"],
            "latitude": receivedDataList[i]["latitude"],
          });
        }
      } catch (e) {
        print("\n\n\n\n\n\n\n\n\n\nSajid nahi howa ha add kuch kar ${e}");
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
          context, MaterialPageRoute(builder: (context) => fourbutton()));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        SizedBox(
          height: 190,
        ),
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(300),
              border: Border.all(width: 2, color: Colors.black)),
          child: ClipOval(
            child: Image.asset(
              ("assets/icons/icon.png"),
              height: 200,
              width: 200,
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
              // color: Color.fromARGB(255, 33, 150, 70),
              color: Color.fromARGB(255, 0x00, 0x60, 0x4F),
              fontSize: 45,
              fontWeight: FontWeight.bold),
        ),
      ],
    )));
  }
}

class data {
  static String datalist = "realtimedata";
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/crop1.txt');
}

Map<String, String> parseStringToMap(String line) {
  try {
    // Preprocess the line to convert it into valid JSON
    line = line
        .replaceAll('{', '{"')
        .replaceAll(':', '":"')
        .replaceAll(', ', '","')
        .replaceAll('}', '"}');

    // Use json.decode to convert the string to a map
    return Map<String, String>.from(json.decode(line));
  } catch (e) {
    // Handle parsing error
    print('Error parsing line: $e');
    return {};
  }
}

Future<List<Map<String, String>>> readCounter(BuildContext context) async {
  try {
    final file = await _localFile;

    // Read content from the file
    String content = await file.readAsString();

    // Split the content into lines
    List<String> lines = content.split('\n');

    // List to store maps
    List<Map<String, String>> mapsList = [];

    // Parse each line into a map
    for (String line in lines) {
      try {
        // Replace this with your actual method to parse a string into a map
        Map<String, String> map = parseStringToMap(line);

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
