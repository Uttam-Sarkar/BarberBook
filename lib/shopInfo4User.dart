import 'package:barberbook/serialDetailsList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopInfo4User extends StatefulWidget {
  final String documentId;
  final String shopName;
  const ShopInfo4User({super.key, required this.documentId, required this.shopName});

  @override
  State<ShopInfo4User> createState() => _ShopInfo4UserState();
}

class _ShopInfo4UserState extends State<ShopInfo4User> {
  //var user = FirebaseAuth.instance.currentUser;
  User? _user;

  @override
  void initState() {
    super.initState();
    // Get the current user
    _user = FirebaseAuth.instance.currentUser;
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(widget.shopName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 500,
              width: double.infinity,
              color: Colors.greenAccent,
              child: widget.documentId!.isNotEmpty ?
              SerialDetail(documentId: widget.documentId,) // access received documetId
                  : Center(
                child: CircularProgressIndicator(),
              ),
            ),
            FloatingActionButton(
                onPressed: (){

                  var user = FirebaseAuth.instance.currentUser;
                  // Handle the input data here (e.g., add to Firestore)
                  var collection = FirebaseFirestore.instance.collection('serialList');
                  var doc = collection
                      .doc( widget.documentId) // <-- Document ID
                      .set({'name': FieldValue.arrayUnion([_user!.displayName])}, SetOptions(merge: true)) // <-- Add data
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
                },
                child:Icon(Icons.add),
            )
          ],
        ),
      )
    );
  }
}
