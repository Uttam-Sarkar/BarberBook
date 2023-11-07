import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PopUp extends StatefulWidget {
  @override
  State<PopUp> createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  //int _count = 0;
int increase(int num) {
  setState(() {
    num++;
  });
  return num;
}
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
              child:Icon(Icons.add),
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
      //  int _count = 0;

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
                int _count = 0;
                print(_count.toString());
                var user = FirebaseAuth.instance.currentUser;
                // Handle the input data here (e.g., add to Firestore)
                var collection = FirebaseFirestore.instance.collection('serialList');
                // fetch current array size and increage it by one
                collection.doc(user!.uid).get().then((documentSnapshot) {
                  if (documentSnapshot.exists) {
                    _count = documentSnapshot.data()?['num'];
                    print("Total1: $_count");
                  } else {
                    print("Document not found or age field is missing.");
                  }
                }).then((value){
                  print("Tota2: $_count");
                  collection.doc(user!.uid).update({
                    'num': increase(_count)
                  });
                }).then((value) {
                  collection
                      .doc(user!.uid) // <-- Document ID
                      .set({'name': FieldValue.arrayUnion(["$inputText-${_count.toString()}"])}, SetOptions(merge: true));
                });

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
