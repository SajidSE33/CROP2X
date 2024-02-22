import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:path_provider/path_provider.dart';

class MyBluetoothApp extends StatefulWidget {
  @override
  _MyBluetoothAppState createState() => _MyBluetoothAppState();
}

class _MyBluetoothAppState extends State<MyBluetoothApp> {
  BluetoothConnection? _connection;
  BluetoothDevice? connectedDevice;
  final String esp32SensorMacAddress = "40:91:51:FC:D1:2A";
  StreamSubscription<Uint8List>? _dataStreamSubscription;
  String dataBuffer = '';
  bool isConnected = false;
  bool isLoading = false;

  String currentId = '0';
  String temperatureValue = '0';
  String conductivityValue = '0';
  String moistureValue = '0';
  String pHValue = '0';
  String nitrogenValue = '0';
  String phosphorusValue = '0';
  String potassiumValue = '0';

  String addidstr = "";
  String addtemstr = "";
  String addcondstr = "";
  String addmoisstr = " ";
  String addphstr = " ";
  String addnitstr = " ";
  String addphosstr = " ";
  String addpotstr = " ";

  List addidlist = [];
  List addtemlist = [];
  List addcondlist = [];
  List addmoislist = [];
  List addphlist = [];
  List addnitlist = [];
  List addphoslist = [];
  List addpotlist = [];

  // List<Map<String, String>> receivedDataList = [];
  List receivedDataList = [];

  StreamController<String> idStream = StreamController<String>.broadcast();
  StreamController<String> temperatureStream =
      StreamController<String>.broadcast();
  StreamController<String> conductivityStream =
      StreamController<String>.broadcast();
  StreamController<String> moistureStream =
      StreamController<String>.broadcast();
  StreamController<String> pHStream = StreamController<String>.broadcast();
  StreamController<String> nitrogenStream =
      StreamController<String>.broadcast();
  StreamController<String> phosphorusStream =
      StreamController<String>.broadcast();
  StreamController<String> potassiumStream =
      StreamController<String>.broadcast();

  int dataCount = 0;

  @override
  void initState() {
    super.initState();
    checkBluetoothState();
  }

  Future<void> checkBluetoothState() async {
    bool? isOn = await FlutterBluetoothSerial.instance.isOn;
    if (isOn != null && !isOn) {
      disconnectFromDevice();
    }
  }

  void _onDataReceived(Uint8List data) {
    String receivedData = utf8.decode(data);
    print('Received data: $receivedData');
    dataBuffer += receivedData;

    while (dataBuffer.contains('{') && dataBuffer.contains('}')) {
      int startIndex = dataBuffer.indexOf('{');
      int endIndex = dataBuffer.indexOf('}') + 1;

      if (startIndex != -1 && endIndex != -1) {
        String completeData = dataBuffer.substring(startIndex, endIndex);
        setState(() {
          try {
            Map<String, dynamic> jsonData = json.decode(completeData);

            idStream.add(jsonData['id'].toString());
            temperatureStream.add(jsonData['t'].toString());
            conductivityStream.add(jsonData['c'].toString());
            moistureStream.add(jsonData['m'].toString());
            pHStream.add(jsonData['pH'].toString());
            nitrogenStream.add(jsonData['n'].toString());
            phosphorusStream.add(jsonData['p'].toString());
            potassiumStream.add(jsonData['k'].toString());

            // Increment the data count
            dataCount++;
          } catch (e) {
            print('Error parsing JSON: $e');
          }
        });

        dataBuffer = dataBuffer.substring(endIndex);
      }
    }
  }

  Future<void> connectToDevice() async {
    BluetoothDevice selectedDevice =
        (await FlutterBluetoothSerial.instance.getBondedDevices()).firstWhere(
      (device) => device.address == esp32SensorMacAddress,
      orElse: () => throw Exception('Device not found'),
    );

    await BluetoothConnection.toAddress(selectedDevice.address)
        .then((BluetoothConnection connection) {
      print('Connected to the device');
      setState(() {
        this._connection = connection;
        this.connectedDevice = selectedDevice;
        _dataStreamSubscription = connection.input?.listen(
          _onDataReceived,
          onDone: () {
            print('Data stream closed.');
          },
          onError: (error) {
            print('Data stream error: $error');
          },
        );

        setState(() {
          _connection = connection;
          isConnected = true;
          isLoading = false;
        });
      });
    }).catchError((error) {
      print('Error connecting to the device: $error');
    });
  }

  Future<void> disconnectFromDevice() async {
    await _connection?.close();
    setState(() {
      _connection = null;
      connectedDevice = null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Device Disconnected'),
        ),
      );
    });
  }

  void adddata() async {
    for (var i = 0; i < receivedDataList.length; i++) {
      var realdata = FirebaseFirestore.instance.collection(data.datalist);
      try {
        if (receivedDataList[i]["id"]==null ) {
          
        }
        else{
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
    receivedDataList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 45),
          child: Text(
            "CROP 2X",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 0, 128, 6),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 23,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 50, 0),
                  child: Text(""),
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 128, 6),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
                  child: Text(""),
                  width: 30,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 128, 6),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                // SizedBox(width: 10,),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(""),
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 128, 6),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 16,
            ),
            Container(
              //////////////main black ----------------
              width: 350,
              height: 540,
              decoration: BoxDecoration(
                border: Border.all(
                  // color: const Color.fromARGB(255, 0, 128, 6),
                  color: Colors.black,
                  width: 5, // Adjust border width here
                ),
                borderRadius:
                    BorderRadius.circular(20), // Adjust border radius here
              ),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: connectToDevice,
                            child: Text(
                              'منسلک کریں',
                              style: TextStyle(
                                // fontFamily: "Gilroy-Bold",
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(140, 5),
                              // side: BorderSide(width: 2),
                              shape: StadiumBorder(),
                              backgroundColor: Color.fromARGB(255, 0, 128, 6),
                            ),
                          ),
                          SizedBox(
                            width: 35,
                          ),
                          ElevatedButton(
                            onPressed: disconnectFromDevice,
                            child: Text(
                              'منقطع',
                              style: TextStyle(
                                // fontFamily: "Gilroy-Bold",
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(140, 5),
                              // side: BorderSide(width: 2),
                              shape: StadiumBorder(),
                              backgroundColor: Color.fromARGB(255, 0, 128, 6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 320,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 0, 128, 6),
                            width: 3, // Adjust border width here
                          ),
                          borderRadius: BorderRadius.circular(
                              20), // Adjust border radius here
                        ),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            connectedDevice == null
                                ? 'منسلک نہیں'
                                : '${connectedDevice!.name} سے جڑا ہوا',
                            style: TextStyle(
                              // fontFamily: "Gilroy-Bold",
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 0, 128, 6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    //container of details ----------------------------//
                    width: 320,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 128, 6),
                        width: 3, // Adjust border width here
                      ),
                      borderRadius: BorderRadius.circular(
                          20), // Adjust border radius here
                    ),
                    // margin: EdgeInsets.only(right: 90),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<String>(
                            stream: idStream.stream,
                            initialData: '',
                            builder: (context, snapshot) {
                              currentId = snapshot.data ?? '';
                              if (snapshot.data != addidstr) {
                                addidstr = snapshot.data ?? '';
                              }
                              return Info(': آئی ڈی',
                                  isConnected ? snapshot.data ?? '' : "");
                            },
                          ),
                          StreamBuilder<String>(
                            stream: temperatureStream.stream,
                            initialData: '',
                            builder: (context, snapshot) {
                              temperatureValue = snapshot.data ?? '';
                              if (snapshot.data != addtemstr) {
                                addtemstr = snapshot.data ?? '';
                              }
                              return Info(': % درجہ حرارت',
                                  isConnected ? snapshot.data ?? '' : "");
                            },
                          ),
                          StreamBuilder<String>(
                            stream: conductivityStream.stream,
                            initialData: '',
                            builder: (context, snapshot) {
                              conductivityValue = snapshot.data ?? '';
                              if (snapshot.data != addcondstr) {
                                addcondstr = snapshot.data ?? '';
                              }
                              return Info(': uS/cmکٹئؤئٹئ',
                                  isConnected ? snapshot.data ?? '' : "");
                            },
                          ),
                          StreamBuilder<String>(
                            stream: moistureStream.stream,
                            initialData: '',
                            builder: (context, snapshot) {
                              moistureValue = snapshot.data ?? '';
                              if (snapshot.data != addmoisstr) {
                                addmoisstr = snapshot.data ?? '';
                              }
                              return Info(': % نمی',
                                  isConnected ? snapshot.data ?? '' : "");
                            },
                          ),
                          StreamBuilder<String>(
                            stream: pHStream.stream,
                            initialData: '',
                            builder: (context, snapshot) {
                              pHValue = snapshot.data ?? '';
                              if (snapshot.data != addphstr) {
                                addphstr = snapshot.data ?? '';
                              }
                              return Info(': پی ایچ',
                                  isConnected ? snapshot.data ?? '' : "");
                            },
                          ),
                          StreamBuilder<String>(
                            stream: nitrogenStream.stream,
                            initialData: '',
                            builder: (context, snapshot) {
                              nitrogenValue = snapshot.data ?? '';
                              if (snapshot.data != addnitstr) {
                                addnitstr = snapshot.data ?? '';
                              }
                              return Info(': mg/Kg نائٹروجن',
                                  isConnected ? snapshot.data ?? '' : "");
                            },
                          ),
                          StreamBuilder<String>(
                            stream: phosphorusStream.stream,
                            initialData: '',
                            builder: (context, snapshot) {
                              phosphorusValue = snapshot.data ?? '';
                              if (snapshot.data != addphosstr) {
                                addphosstr = snapshot.data ?? '';
                              }
                              return Info(': mg/Kg فاسفورس',
                                  isConnected ? snapshot.data ?? '' : "");
                            },
                          ),
                          StreamBuilder<String>(
                            stream: potassiumStream.stream,
                            initialData: '',
                            builder: (context, snapshot) {
                              potassiumValue = snapshot.data ?? '';
                              if (snapshot.data != addpotstr) {
                                addpotstr = snapshot.data ?? '';
                              }
                              return Info(': mg/Kg پوٹاشیم',
                                  isConnected ? snapshot.data ?? '' : "");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Display the count of received data items
                  // Text('Data Count: $dataCount'),//-------------------for testing
                  ElevatedButton(
                    onPressed: () {
                      Map<String, String> adddatmap = {
                        "id": addidstr,
                        "c": addcondstr,
                        "k": addpotstr,
                        "m": addmoisstr,
                        "n": addnitstr,
                        "p": addphosstr,
                        "pH": addphstr,
                        "t": addtemstr
                      };
                      print("  hogya maping      ${adddatmap}");
                      String mapAsString = adddatmap.toString();
                      writeCounter(mapAsString, context);
                    },
                    child: Text(
                      'محفوظ کریں۔',
                      style: TextStyle(
                        // fontFamily: "Gilroy-Bold",
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 5),
                      // side: BorderSide(width: 2),
                      shape: StadiumBorder(),
                      backgroundColor: Color.fromARGB(255, 0, 128, 6),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            receivedDataList = await readCounter(context);
                            adddata();
                            await (await _localFile).writeAsString('');
                          },
                          child: Text("Add Data")),
                      ElevatedButton(
                          onPressed: () async {
                            List receivedData = await readCounter(context);
                            print(receivedData);
                          },
                          child: Text("Show Data"))
                    ],
                  )
                ],
              ),
            ),

            //last design pattern -----------------------------
            SizedBox(
              height: 18,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 50, 0),
                  child: Text(""),
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 128, 6),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
                  child: Text(""),
                  width: 30,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 128, 6),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                // SizedBox(width: 10,),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(""),
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 128, 6),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    disconnectFromDevice();
    idStream.close();
    temperatureStream.close();
    conductivityStream.close();
    moistureStream.close();
    pHStream.close();
    nitrogenStream.close();
    phosphorusStream.close();
    potassiumStream.close();
    super.dispose();
  }
}

Widget Info(String label, String data) {
  return Row(
    children: [
      Container(
        width: 180,
        height: 23,
        child: Text(
          data,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        alignment: Alignment.centerRight,
      ),
      SizedBox(
        width: 10,
      ),
      Container(
        width: 180,
        height: 23,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        alignment: Alignment.centerLeft,
      ),
    ],
  );
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
  return File('$path/data.txt');
}

Future<void> writeCounter(String counter, BuildContext context) async {
  try {
    final file = await _localFile;

    // Read existing content
    String existingContent = '';
    if (file.existsSync()) {
      existingContent = await file.readAsString();
    }

    // Append new content with a new line
    String newContent = '$existingContent\n$counter';

    // Write back to the file
    await file.writeAsString(newContent);

    // Print the complete path to the terminal
    print('File saved at: ${file.path}');
  } catch (e) {
    
  }
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

