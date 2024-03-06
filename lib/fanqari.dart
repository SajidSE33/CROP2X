// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// // ignore: unused_import
// import 'package:audioplayers/audioplayers.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:cropx/splashscreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:vibration/vibration.dart';

// class MyBluetoothApp extends StatefulWidget {
//   @override
//   _MyBluetoothAppState createState() => _MyBluetoothAppState();
// }

// class _MyBluetoothAppState extends State<MyBluetoothApp> {
//   BluetoothConnection? _connection;
//   BluetoothDevice? connectedDevice;
//   String latitude = '';
//   String longitude = '';
//   String currentDate = '';
//   String currentTime = '';
//   late StreamSubscription<Position> _positionStreamSubscription;
//   late Timer _timer;

//   //  final String esp32SensorMacAddress = "E4:65:B8:84:05:EA";
//   final String esp32SensorMacAddress = "40:91:51:FC:D1:2A";
//   StreamSubscription<Uint8List>? _dataStreamSubscription;
//   String dataBuffer = '';
//   bool isConnected = false;
//   bool isLoading = false;
//   bool soundAndVibrationCalled = false;

//   String currentId = '0';
//   String temperatureValue = '0';
//   String conductivityValue = '0';
//   String moistureValue = '0';
//   String pHValue = '0';
//   String nitrogenValue = '0';
//   String phosphorusValue = '0';
//   String potassiumValue = '0';

//   String addidstr = " ";
//   String addtemstr = " ";
//   String addcondstr = " ";
//   String addmoisstr = " ";
//   String addphstr = " ";
//   String addnitstr = " ";
//   String addphosstr = " ";
//   String addpotstr = " ";
//   List<Map<String, String>> receivedDataList = [];
//   List<Map<String, String>> DataList = [];

//   StreamController<String> idStream = StreamController<String>.broadcast();
//   StreamController<String> temperatureStream =
//   StreamController<String>.broadcast();
//   StreamController<String> conductivityStream =
//   StreamController<String>.broadcast();
//   StreamController<String> moistureStream =
//   StreamController<String>.broadcast();
//   StreamController<String> pHStream = StreamController<String>.broadcast();
//   StreamController<String> nitrogenStream =
//   StreamController<String>.broadcast();
//   StreamController<String> phosphorusStream =
//   StreamController<String>.broadcast();
//   StreamController<String> potassiumStream =
//   StreamController<String>.broadcast();

//   int dataCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     checkBluetoothState();
//     _listenForLocationChanges();
//     connectToDevice();
//     _updateDateTime(); // Initial update
//     _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
//       _updateDateTime(); // Update every second
//     });
//   }

//   Future<void> checkBluetoothState() async {
//     bool? isOn = await FlutterBluetoothSerial.instance.isOn;
//     if (isOn != null && !isOn) {
//       disconnectFromDevice();
//     }
//   }

//   void performVibration(BuildContext context) {
//     try {
//       Vibration.vibrate();
//     } catch (e) {}
//   }

//   Future<void> playSound() async {
//     String url = 'sound.mp3';
//     final player = AudioPlayer();
//     await player.play(AssetSource(url));
//   }

//   // void _listenForLocationChanges() {
//   //   _positionStreamSubscription =
//   //       Geolocator.getPositionStream().listen((Position position) {
//   //     setState(() {
//   //       latitude = position.latitude.toString();
//   //       longitude = position.longitude.toString();
//   //     });
//   //   });
//   // }
//   void _listenForLocationChanges() {
//     // Request continuous location updates
//     _positionStreamSubscription = Geolocator.getPositionStream().listen(
//           (Position position) {
//         setState(() {
//           latitude = position.latitude.toString();
//           longitude = position.longitude.toString();
//         });
//       },
//       onError: (dynamic error) => print('Error: $error'),
//       onDone: () => print('Done!'),
//       cancelOnError: false,
//     );
//   }

//   void _updateDateTime() {
//     DateTime now = DateTime.now();
//     setState(() {
//       currentDate =
//       '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString()
//           .padLeft(2, '0')}';
//       currentTime =
//       '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(
//           2, '0')}:${now.second.toString().padLeft(2, '0')}';
//     });
//   }

//   void _onDataReceived(Uint8List data) {
//     String receivedData = utf8.decode(data);
//     print('Received data: $receivedData');
//     dataBuffer += receivedData;

//     while (dataBuffer.contains('{') && dataBuffer.contains('}')) {
//       int startIndex = dataBuffer.indexOf('{');
//       int endIndex = dataBuffer.indexOf('}') + 1;

//       if (startIndex != -1 && endIndex != -1) {
//         String completeData = dataBuffer.substring(startIndex, endIndex);
//         setState(() {
//           try {
//             Map<String, dynamic> jsonData = json.decode(completeData);

//             idStream.add(jsonData['id'].toString());
//             temperatureStream.add(jsonData['t'].toString());
//             conductivityStream.add(jsonData['c'].toString());
//             moistureStream.add(jsonData['m'].toString());
//             pHStream.add(jsonData['pH'].toString());
//             nitrogenStream.add(jsonData['n'].toString());
//             phosphorusStream.add(jsonData['p'].toString());
//             potassiumStream.add(jsonData['k'].toString());

//             // Increment the data count
//             dataCount++;
//           } catch (e) {
//             print('Error parsing JSON: $e');
//           }
//         });

//         dataBuffer = dataBuffer.substring(endIndex);
//       }
//     }
//   }

//   Future<void> connectToDevice() async {
//     BluetoothDevice selectedDevice =
//     (await FlutterBluetoothSerial.instance.getBondedDevices()).firstWhere(
//           (device) => device.address == esp32SensorMacAddress,
//       orElse: () => throw Exception('Device not found'),
//     );

//     await BluetoothConnection.toAddress(selectedDevice.address)
//         .then((BluetoothConnection connection) {
//       print('Connected to the device');
//       setState(() {
//         this._connection = connection;
//         this.connectedDevice = selectedDevice;
//         _dataStreamSubscription = connection.input?.listen(
//           _onDataReceived,
//           onDone: () {
//             print('Data stream closed.');
//           },
//           onError: (error) {
//             print('Data stream error: $error');
//           },
//         );

//         setState(() {
//           _connection = connection;
//           isConnected = true;
//           isLoading = false;
//         });
//       });
//     }).catchError((error) {
//       print('Error connecting to the device: $error');
//     });
//   }

//   Future<void> disconnectFromDevice() async {
//     await _connection?.close();
//     setState(() {
//       _connection = null;
//       connectedDevice = null;
//     });
//   }

//   Map<String, String> average(List<Map<String, String>> list) {
//     Map<String, int> sumMap = {
//       'c': 0,
//       'k': 0,
//       'm': 0,
//       'n': 0,
//       'p': 0,
//       'pH': 0,
//       't': 0,
//     };

//     // Add the values of 'c', 'k', 'm', 'n', 'p', 'pH', and 't' from all maps in the list
//     for (var map in list) {
//       map.forEach((key, value) {
//         if (sumMap.containsKey(key)) {
//           sumMap[key] = (sumMap[key] ?? 0) +
//               (int.tryParse(value) ??
//                   0); // Use null-aware operators to handle null case
//         }
//       });
//     }

//     // Calculate the average for each key
//     int length = list.length;
//     sumMap.forEach((key, value) {
//       sumMap[key] = value ~/ length;
//     });

//     // Create a new map containing the averages and retain the values of 'date', 'time', 'id', 'latitude', and 'longitude' from the first map
//     Map<String, String> avgMap = {};
//     list[0].forEach((key, value) {
//       if (sumMap.containsKey(key)) {
//         avgMap[key] = sumMap[key].toString();
//       } else {
//         avgMap[key] = value;
//       }
//     });

//     return avgMap;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Padding(
//           padding: EdgeInsets.only(left: 45),
//           child: Text(
//             "CROP 2X",
//             style: TextStyle(
//               fontSize: 30,
//               fontWeight: FontWeight.w700,
//               color: Color.fromARGB(255, 255, 255, 255),
//             ),
//           ),
//         ),
//         elevation: 0,
//         backgroundColor: const Color.fromARGB(255, 0, 128, 6),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 Container(
//                   margin: EdgeInsets.fromLTRB(20, 0, 50, 0),
//                   child: Text(""),
//                   width: 80,
//                   height: 7,
//                   decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 0, 128, 6),
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Container(
//                   margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
//                   child: Text(""),
//                   width: 30,
//                   height: 7,
//                   decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 0, 128, 6),
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//                 // SizedBox(width: 10,),
//                 Container(
//                   margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
//                   child: Text(""),
//                   width: 80,
//                   height: 7,
//                   decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 0, 128, 6),
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(
//               height: 10,
//             ),
//             Container(
//               //////////////main black ----------------
//               width: 350,
//               height: 600,
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   // color: const Color.fromARGB(255, 0, 128, 6),
//                   color: Colors.black,
//                   width: 3, // Adjust border width here
//                 ),
//                 borderRadius:
//                 BorderRadius.circular(20), // Adjust border radius here
//               ),
//               child: Column(
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         height: 7,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ElevatedButton(
//                             onPressed: connectToDevice,
//                             child: Text(
//                               'منسلک کریں',
//                               style: TextStyle(
//                                 // fontFamily: "Gilroy-Bold",
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               fixedSize: Size(140, 5),
//                               // side: BorderSide(width: 2),
//                               shape: StadiumBorder(),
//                               backgroundColor: Color.fromARGB(255, 0, 128, 6),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 35,
//                           ),
//                           ElevatedButton(
//                             onPressed: disconnectFromDevice,
//                             child: Text(
//                               'منقطع',
//                               style: TextStyle(
//                                 // fontFamily: "Gilroy-Bold",
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               fixedSize: Size(140, 5),
//                               // side: BorderSide(width: 2),
//                               shape: StadiumBorder(),
//                               backgroundColor: Color.fromARGB(255, 0, 128, 6),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 7,
//                       ),
//                       Container(
//                         width: 320,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: const Color.fromARGB(255, 0, 128, 6),
//                             width: 3, // Adjust border width here
//                           ),
//                           borderRadius: BorderRadius.circular(
//                               20), // Adjust border radius here
//                         ),
//                         child: Center(
//                           child: Text(
//                             textAlign: TextAlign.center,
//                             connectedDevice == null
//                                 ? 'منسلک نہیں'
//                                 : 'سے جڑا ہوا ${connectedDevice!.name}',
//                             style: TextStyle(
//                               // fontFamily: "Gilroy-Bold",
//                               fontSize: 17,
//                               fontWeight: FontWeight.w700,
//                               color: Color.fromARGB(255, 0, 128, 6),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 7,
//                   ),
//                   Container(
//                     padding: EdgeInsets.only(bottom: 20),
//                     //container of details ----------------------------//
//                     width: 330,
//                     height: 250,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: const Color.fromARGB(255, 0, 128, 6),
//                         width: 3, // Adjust border width here
//                       ),
//                       borderRadius: BorderRadius.circular(
//                           20), // Adjust border radius here
//                     ),
//                     // margin: EdgeInsets.only(right: 90),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             margin: EdgeInsets.fromLTRB(0, 0, 60, 10),
//                             child: StreamBuilder<String>(
//                               stream: idStream.stream,
//                               initialData: '',
//                               builder: (context, snapshot) {
//                                 currentId = snapshot.data ?? '';
//                                 if (snapshot.data != addidstr) {
//                                   addidstr = snapshot.data ?? '';
//                                 }

//                                 // Check if snapshot data is not empty before displaying the text
//                                 String displayText =
//                                 isConnected ? snapshot.data ?? '' : "";
//                                 TextSpan textSpan = TextSpan(
//                                   text: ' آئی ڈی ',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 20,
//                                     color: Color.fromARGB(255, 0, 128, 6),
//                                   ),
//                                   children: [
//                                     TextSpan(
//                                       text: displayText,
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20,
//                                         color: Color.fromARGB(255, 0, 128, 6),
//                                       ),
//                                     ),
//                                   ],
//                                 );

//                                 // Use RichText to display the styled text
//                                 return RichText(
//                                   text: textSpan,
//                                 );
//                               },
//                             ),
//                           ),
//                           StreamBuilder<String>(
//                             stream: temperatureStream.stream,
//                             initialData: '',
//                             builder: (context, snapshot) {
//                               temperatureValue = snapshot.data ?? '';
//                               if (snapshot.data != addtemstr) {
//                                 addtemstr = snapshot.data ?? '';
//                               }
//                               return Info(': % درجہ حرارت',
//                                   isConnected ? snapshot.data ?? '' : "");
//                             },
//                           ),
//                           StreamBuilder<String>(
//                             stream: conductivityStream.stream,
//                             initialData: '',
//                             builder: (context, snapshot) {
//                               conductivityValue = snapshot.data ?? '';
//                               if (snapshot.data != addcondstr) {
//                                 addcondstr = snapshot.data ?? '';
//                               }
//                               return Info(': uS/cmکٹئؤئٹئ',
//                                   isConnected ? snapshot.data ?? '' : "");
//                             },
//                           ),
//                           StreamBuilder<String>(
//                             stream: moistureStream.stream,
//                             initialData: '',
//                             builder: (context, snapshot) {
//                               moistureValue = snapshot.data ?? '';
//                               if (addmoisstr == '0') {
//                                 soundAndVibrationCalled = false;
//                               }
//                               if (addmoisstr != '0') {
//                                 List DataList = [];
//                                 // Check if the functions haven't been called yet
//                                 if (!soundAndVibrationCalled) {
//                                   soundAndVibrationCalled =
//                                   true; // Set the flag to true
//                                   Future.delayed(Duration(seconds: 7), () {
//                                     // playSound();
//                                     // performVibration(context);
//                                     const duration = Duration(seconds: 3);
//                                     int counter = 1;
//                                     Timer.periodic(
//                                         duration, (Timer timer) async {
//                                       counter++;
//                                       if (counter < 5) {
//                                         Map<String, String> adddatmap = {
//                                           "date": currentDate,
//                                           "time":
//                                           currentTime.replaceAll(':', '-'),
//                                           "id": addidstr,
//                                           "c": addcondstr,
//                                           "k": addpotstr,
//                                           "m": addmoisstr,
//                                           "n": addnitstr,
//                                           "p": addphosstr,
//                                           "pH": addphstr,
//                                           "t": addtemstr,
//                                           "latitude": latitude,
//                                           "longitude": longitude,
//                                         };
//                                         receivedDataList.add(adddatmap);
//                                       }
//                                       if (counter == 5) {
//                                         performVibration(context);
//                                         playSound();
//                                         timer.cancel();
//                                         Map<String, String> avgMap =
//                                         average(receivedDataList);
//                                         String mapAsString = avgMap.toString();
//                                         writeCounter(mapAsString, context);
//                                         if (await isConnectionAvailable(
//                                             context)) {
//                                           print("connection available");
//                                           DataList = await readCounter(context);
//                                           savedata();
//                                         } else {
//                                           print("no connection available");
//                                         }

//                                         // print("\n\n\n");
//                                         //   print("dakh la bhai ankh khool ka");
//                                         //   print(avgMap);
//                                       }
//                                     });
//                                   });
//                                 }
//                               } else {
//                                 // Reset the flag when addmoisstr is '0'
//                                 soundAndVibrationCalled = false;
//                               }
//                               return Info(': % نمی',
//                                   isConnected ? snapshot.data ?? '' : "");
//                             },
//                           ),
//                           StreamBuilder<String>(
//                             stream: pHStream.stream,
//                             initialData: '',
//                             builder: (context, snapshot) {
//                               pHValue = snapshot.data ?? '';
//                               if (snapshot.data != addphstr) {
//                                 addphstr = snapshot.data ?? '';
//                               }
//                               return Info(': پی ایچ',
//                                   isConnected ? snapshot.data ?? '' : "");
//                             },
//                           ),
//                           StreamBuilder<String>(
//                             stream: nitrogenStream.stream,
//                             initialData: '',
//                             builder: (context, snapshot) {
//                               nitrogenValue = snapshot.data ?? '';
//                               if (snapshot.data != addnitstr) {
//                                 addnitstr = snapshot.data ?? '';
//                               }
//                               return Info(': mg/Kg نائٹروجن',
//                                   isConnected ? snapshot.data ?? '' : "");
//                             },
//                           ),
//                           StreamBuilder<String>(
//                             stream: phosphorusStream.stream,
//                             initialData: '',
//                             builder: (context, snapshot) {
//                               phosphorusValue = snapshot.data ?? '';
//                               if (snapshot.data != addphosstr) {
//                                 addphosstr = snapshot.data ?? '';
//                               }
//                               return Info(': mg/Kg فاسفورس',
//                                   isConnected ? snapshot.data ?? '' : "");
//                             },
//                           ),
//                           StreamBuilder<String>(
//                             stream: potassiumStream.stream,
//                             initialData: '',
//                             builder: (context, snapshot) {
//                               potassiumValue = snapshot.data ?? '';
//                               if (snapshot.data != addpotstr) {
//                                 addpotstr = snapshot.data ?? '';
//                               }
//                               return Info(': mg/Kg پوٹاشیم',
//                                   isConnected ? snapshot.data ?? '' : "");
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // Display the count of received data items
//                   Text(
//                       'Data Count: $dataCount'),
//                   //-------------------for testing
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Column(
//                     children: [
//                       Container(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               longitude,
//                               style: TextStyle(
//                                   fontSize: 17, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               ": طول البلد",
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             )
//                           ],
//                         ),
//                       ),
//                       Container(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               latitude,
//                               style: TextStyle(
//                                   fontSize: 17, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               ": عرض البلد",
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             )
//                           ],
//                         ),
//                       ),
//                       Container(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               currentDate,
//                               style: TextStyle(
//                                   fontSize: 17, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               ": تاریخ",
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             )
//                           ],
//                         ),
//                       ),
//                       Container(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               currentTime,
//                               style: TextStyle(
//                                   fontSize: 17, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               ": اوقات",
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),

//                   // ElevatedButton(
//                   //   onPressed: () {
//                   //     Map<String, String> adddatmap = {
//                   //       "date": currentDate,
//                   //       "time": currentTime.replaceAll(':', '-'),
//                   //       "id": addidstr,
//                   //       "c": addcondstr,
//                   //       "k": addpotstr,
//                   //       "m": addmoisstr,
//                   //       "n": addnitstr,
//                   //       "p": addphosstr,
//                   //       "pH": addphstr,
//                   //       "t": addtemstr,
//                   //       "latitude": latitude,
//                   //       "longitude": longitude,
//                   //     };
//                   //     print("  hogya maping      ${adddatmap}");
//                   //     String mapAsString = adddatmap.toString();
//                   //     writeCounter(mapAsString, context);
//                   //   },
//                   //   child: Text(
//                   //     'محفوظ کریں۔',
//                   //     style: TextStyle(
//                   //       // fontFamily: "Gilroy-Bold",
//                   //       fontSize: 17,
//                   //       fontWeight: FontWeight.w700,
//                   //       color: Colors.white,
//                   //     ),
//                   //   ),
//                   //   style: ElevatedButton.styleFrom(
//                   //     fixedSize: Size(200, 5),
//                   //     // side: BorderSide(width: 2),
//                   //     shape: StadiumBorder(),
//                   //     backgroundColor: Color.fromARGB(255, 0, 128, 6),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),

//             //last design pattern -----------------------------
//             SizedBox(
//               height: 18,
//             ),
//             Row(
//               children: [
//                 Container(
//                   margin: EdgeInsets.fromLTRB(20, 0, 50, 0),
//                   child: Text(""),
//                   width: 80,
//                   height: 12,
//                   decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 0, 128, 6),
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Container(
//                   margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
//                   child: Text(""),
//                   width: 30,
//                   height: 12,
//                   decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 0, 128, 6),
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//                 // SizedBox(width: 10,),
//                 Container(
//                   margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
//                   child: Text(""),
//                   width: 80,
//                   height: 12,
//                   decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 0, 128, 6),
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     disconnectFromDevice();
//     idStream.close();
//     temperatureStream.close();
//     conductivityStream.close();
//     moistureStream.close();
//     pHStream.close();
//     nitrogenStream.close();
//     phosphorusStream.close();
//     potassiumStream.close();
//     _positionStreamSubscription?.cancel();
//     _timer.cancel();
//     super.dispose();
//   }

//   Future<bool> isConnectionAvailable(BuildContext context) async {
//     final connectivityResult = await Connectivity().checkConnectivity();

//     if (connectivityResult == ConnectivityResult.none) {
//       return false;
//     }

//     return true;
//   }


//   Widget Info(String label, String data) {
//     return Row(
//       children: [
//         Container(
//           width: 180,
//           height: 23,
//           child: Text(
//             data,
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           alignment: Alignment.centerRight,
//         ),
//         SizedBox(
//           width: 10,
//         ),
//         Container(
//           width: 180,
//           height: 23,
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           alignment: Alignment.centerLeft,
//         ),
//       ],
//     );
//   }

//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }

//   Future<File> get _localFile async {
//     final path = await _localPath;
//     return File('$path/data.txt');
//   }

//   Future<void> writeCounter(String counter, BuildContext context) async {
//     try {
//       final file = await _localFile;
//       String existingContent = '';
//       if (file.existsSync()) {
//         existingContent = await file.readAsString();
//       }
//       String newContent = '$existingContent\n$counter';
//       await file.writeAsString(newContent);
//       print('File saved at: ${file.path}');
//     } catch (e) {}
//   }

//   void savedata() async {
//     print(" ${DataList}");
//     print("\n");
//     print("\n");
//     print("\n");
//     print("\n");
//     print("\n");
//     for (var i = 0; i < DataList.length; i++) {
//       var realdata = FirebaseFirestore.instance.collection(data.datalist);
//       try {
//         if (DataList[i]["id"] == null) {} else {
//           String? date = DataList[i]["date"];
//           String? time = DataList[i]["time"];
//           time = time?.replaceAll('-', ':');
//           String doc1 = "$date-$time";
//           await realdata.doc(doc1).set({
//             "id": DataList[i]["id"],
//             "conductivity": DataList[i]["c"],
//             "potassium": DataList[i]["k"],
//             "moisture": DataList[i]["m"],
//             "nitrogen": DataList[i]["n"],
//             "phosphor": DataList[i]["p"],
//             "pH": DataList[i]["pH"],
//             "temperature": DataList[i]["t"],
//             "longitude": DataList[i]["longitude"],
//             "latitude": DataList[i]["latitude"],

//           });
//         }
//       } catch (e) {
//         print(" ${e}");
//       }
//     }
//     await (await _localFile).writeAsString('');
//     DataList.clear();
//     print("\n");
//     print("\n");
//     print("\n");
//     print("\n");
//     print("\n");
//     print("Txt Content    ${readCounter(context)}");
//   }

// }