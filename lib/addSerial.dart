import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FloatingActionButton(
          onPressed: () {
            _showInputPopup(context);
          },
          child:Icon(Icons.add),
        )
      ),
    );
  }

  void _showInputPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = "Customer";

        return AlertDialog(
          title: Text('Input Name'),
          content: TextField(
            onChanged: (text) {
              inputText = text;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                var user = FirebaseAuth.instance.currentUser;
                // Handle the input data here (e.g., add to Firestore)
                var collection = FirebaseFirestore.instance.collection('serialList');
                var doc = collection
                    .doc('${user!.uid}') // <-- Document ID
                    .set({'name': FieldValue.arrayUnion(["${inputText}"])}, SetOptions(merge: true)) // <-- Add data
                    .then((value) {
                  print('Added');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.green,
                        content: Center(
                          child: Text("Added Successfully"),
                        )
                    ),
                  );
                   })
                    .catchError((error) {
                  print('Add failed: $error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.red,
                        content: Center(
                          child: Text("Something Wrong"),
                        )
                    ),
                  );
                } );
                print('Entered text: $inputText');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
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
