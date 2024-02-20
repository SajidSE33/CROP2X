import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

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

  List<Map<String, int>> receivedDataList = [];

  StreamController<String> idStream = StreamController<String>.broadcast();
  StreamController<String> temperatureStream = StreamController<String>.broadcast();
  StreamController<String> conductivityStream = StreamController<String>.broadcast();
  StreamController<String> moistureStream = StreamController<String>.broadcast();
  StreamController<String> pHStream = StreamController<String>.broadcast();
  StreamController<String> nitrogenStream = StreamController<String>.broadcast();
  StreamController<String> phosphorusStream = StreamController<String>.broadcast();
  StreamController<String> potassiumStream = StreamController<String>.broadcast();

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
    BluetoothDevice selectedDevice = (await FlutterBluetoothSerial.instance.getBondedDevices())
        .firstWhere(
      (device) => device.address == esp32SensorMacAddress,
      orElse: () => throw Exception('Device not found'),
    );

    await BluetoothConnection.toAddress(selectedDevice.address).then((BluetoothConnection connection) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop 2x project'),
      ),
      body: Center(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: connectToDevice,
                  child: Text('Connect'),
                ),
                SizedBox(width: 4),
                ElevatedButton(
                  onPressed: disconnectFromDevice,
                  child: Text('Disconnect'),
                ),
                SizedBox(width: 4),
                Text(
                  connectedDevice == null
                      ? 'Not Connected'
                      : 'Connected to ${connectedDevice!.name}',
                ),
              ],
            ),
            SizedBox(height: 30),
            Container(
              width: 300,
              margin: EdgeInsets.only(right: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<String>(
                    stream: idStream.stream,
                    initialData: '',
                    builder: (context, snapshot) {
                      currentId = snapshot.data ?? '';
                      return Info(': آئی ڈی', isConnected ? snapshot.data ?? '' : "");
                    },
                  ),
                  StreamBuilder<String>(
                    stream: temperatureStream.stream,
                    initialData: '',
                    builder: (context, snapshot) {
                      temperatureValue = snapshot.data ?? '';
                      return Info(': % درجہ حرارت', isConnected ? snapshot.data ?? '' : "");
                    },
                  ),
                  StreamBuilder<String>(
                    stream: conductivityStream.stream,
                    initialData: '',
                    builder: (context, snapshot) {
                      conductivityValue = snapshot.data ?? '';
                      return Info(':uS/cmکٹئؤئٹئ', isConnected ? snapshot.data ?? '' : "");
                    },
                  ),
                  StreamBuilder<String>(
                    stream: moistureStream.stream,
                    initialData: '',
                    builder: (context, snapshot) {
                      moistureValue = snapshot.data ?? '';
                      return Info(': % نمی', isConnected ? snapshot.data ?? '' : "");
                    },
                  ),
                  StreamBuilder<String>(
                    stream: pHStream.stream,
                    initialData: '',
                    builder: (context, snapshot) {
                      pHValue = snapshot.data ?? '';
                      return Info(': پی ایچ', isConnected ? snapshot.data ?? '' : "");
                    },
                  ),
                  StreamBuilder<String>(
                    stream: nitrogenStream.stream,
                    initialData: '',
                    builder: (context, snapshot) {
                      nitrogenValue = snapshot.data ?? '';
                      return Info(': mg/Kg نائٹروجن', isConnected ? snapshot.data ?? '' : "");
                    },
                  ),
                  StreamBuilder<String>(
                    stream: phosphorusStream.stream,
                    initialData: '',
                    builder: (context, snapshot) {
                      phosphorusValue = snapshot.data ?? '';
                      return Info(': mg/Kg فاسفورس', isConnected ? snapshot.data ?? '' : "");
                    },
                  ),
                  StreamBuilder<String>(
                    stream: potassiumStream.stream,
                    initialData: '',
                    builder: (context, snapshot) {
                      potassiumValue = snapshot.data ?? '';
                      return Info(': mg/Kg پوٹاشیم', isConnected ? snapshot.data ?? '' : "");
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Display the count of received data items
            Text('Data Count: $dataCount'),
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