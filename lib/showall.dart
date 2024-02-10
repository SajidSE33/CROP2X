import 'package:cropx/detailed_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class showalldata extends StatefulWidget {
  showalldata({super.key});

  final ref = FirebaseDatabase.instance.ref("crop");

  @override
  State<showalldata> createState() => _showalldataState();
}

class _showalldataState extends State<showalldata> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 33, 150, 70),
        title: Padding(padding: const EdgeInsets.fromLTRB(0, 0, 60, 0),child: const Center(
          child: Text(
            "CROP 2X",
            style: TextStyle(
              fontSize: 30,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),)
      ),
      backgroundColor: Color.fromARGB(255, 182, 205, 185),
      body: Center(
        child: Expanded(
          child: FirebaseAnimatedList(
            query: widget.ref,
            itemBuilder: (context, snapshot, animation, index) {
              Map keys = snapshot.value as Map;
              keys['name'] = snapshot.key;

              // Extract data from the snapshot
              String name = snapshot
                  .child('name')
                  .value
                  .toString(); // Updated this line to get the crop name
              String image = snapshot.child('image').value.toString();
              String temperature =
                  snapshot.child('temperature').value.toString();
              String p = snapshot.child('PH').value.toString();
              String naming = snapshot.child('naming').value.toString();
              String humidity = snapshot.child('humidity').value.toString();
              String nitrogen = snapshot.child('nitrogen').value.toString();
              String waterlevel = snapshot.child('waterlevel').value.toString();

              return GestureDetector(
                onTap: () {
                  // Navigate to the detail screen with the selected data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        // name: name,
                        naming:naming,
                        image: image,
                        temperature: temperature,
                        ph: p,
                        humidity: humidity,
                        nitrogen: nitrogen,
                        waterlevel: waterlevel,
                        keys: keys,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    title: Text(naming), // Display the crop name as the title
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(image),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
