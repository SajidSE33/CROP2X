import 'package:cropx/home.dart';
import 'package:cropx/location.dart';
import 'package:cropx/loginorsignup.dart';
import 'package:cropx/qure.dart';
import 'package:cropx/realtimedevicedata.dart';
import 'package:flutter/material.dart';

class fourbutton extends StatefulWidget {
  const fourbutton({super.key});

  @override
  State<fourbutton> createState() => _fourbuttonState();
}

class _fourbuttonState extends State<fourbutton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 30),
          child: Text(
            "CROP 2X",
            style: TextStyle(
              fontSize: 30,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 33, 150, 70),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 33, 150, 70),
              ),
              child: Center(
                child: Text(
                  "CROP 2X",
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.home,
                  color: const Color.fromARGB(255, 33, 150, 70),
                ),
              ),
              title: const Text('گھر',
                  style: TextStyle(fontSize: 16, color: Colors.brown)),
              onTap: () {},
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.settings,
                    color: const Color.fromARGB(255, 33, 150, 70)),
              ),
              title: const Text(
                'سیٹنگ',
                style: TextStyle(fontSize: 16, color: Colors.brown),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.logout,
                    color: const Color.fromARGB(255, 33, 150, 70)),
              ),
              title: const Text('باہر جائیں',
                  style: TextStyle(fontSize: 16, color: Colors.brown)),
              onTap: () {
                Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => secondmain()),
        );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Image.asset(
                  "images/fourthbutton.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 5, color: Colors.brown),
                  borderRadius: BorderRadius.circular(200)),
              height: 150,
              width: 150,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => real()),
                  );
                },
                child: Center(
                  child: ClipOval(
                    child: Image.asset("images/cloud.png"),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Container(
              child: Text(
                "ریئل ٹائم فصلوں کا ڈیٹا",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 5, color: Colors.brown),
                  borderRadius: BorderRadius.circular(200)),
              height: 150,
              width: 150,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => home()),
                  );
                },
                child: Center(
                  child: ClipOval(
                    child: Image.asset("images/wheat.png"),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Container(
              child: Text(
                "فصل کی ترقی کی تفصیل",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 5, color: Colors.brown),
                  borderRadius: BorderRadius.circular(200)),
              height: 150,
              width: 150,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => location()),
                  );
                },
                child: Center(
                  child: ClipOval(
                    child: Image.asset("images/location.png"),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Container(
              child: Text(
                "کسان کا مقام",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(width: 5, color: Colors.brown),
                    borderRadius: BorderRadius.circular(200)),
                height: 150,
                width: 150,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => authentication()),
                    );
                  },
                  child: Center(
                    child: ClipOval(
                      child: Image.asset("images/feedback.png"),
                    ),
                  ),
                )),
            SizedBox(
              height: 3,
            ),
            Container(
              child: Text(
                "فیڈ بیک فارم",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown),
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        )),
      ),
    );
  }
}
