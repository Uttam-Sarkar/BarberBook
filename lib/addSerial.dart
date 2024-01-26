import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddSerial extends StatefulWidget {
  const AddSerial({super.key});

  @override
  State<AddSerial> createState() => _AddSerialState();
}

class _AddSerialState extends State<AddSerial> {
  // var db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: FloatingActionButton(
              onPressed: () {
                _showInputPopup(context);
              },
              child:const Icon(Icons.add),

            )
          ),
        ],
      ),
    );
  }

  void _showInputPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = "Customer";

        return AlertDialog(
          title: const Text('Input Name'),
          content: TextField(
            onChanged: (text) {
              inputText = text;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                int count = 1;
                // print(_count.toString());
                var user = FirebaseAuth.instance.currentUser;
                // Handle the input data here (e.g., add to Firestore)
                var collection = FirebaseFirestore.instance.collection('serialList');
                collection.doc(user!.uid).get().then((documentSnapshot) {
                  if (documentSnapshot.exists) {
                    //array/serial_list length
                    count = documentSnapshot.data()?['name'].length;
                  }
                }).then((value) {
                  var data = collection.doc(user!.uid); // <-- Document ID
                      data.set({'name': FieldValue.arrayUnion(["$inputText-${(count+1).toString()}"])}, SetOptions(merge: true));
                      data.set({'total' : count+1},SetOptions(merge: true));
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
