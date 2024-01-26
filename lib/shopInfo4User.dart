import 'package:barberbook/serialDetailsList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class ShopInfo4User extends StatefulWidget {
  final String documentId;
  final String shopName;
  const ShopInfo4User(
      {super.key, required this.documentId, required this.shopName});

  @override
  State<ShopInfo4User> createState() => _ShopInfo4UserState();
}

class _ShopInfo4UserState extends State<ShopInfo4User> {
  var userName = "user";
  User? _user;

  @override
  void initState() {
    super.initState();
    _fetchFromLocalStorage();
    // Get the current user

    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.shopName),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 18, bottom: 5, left: 10, right: 10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: widget.documentId!.isNotEmpty
                    ? SerialDetail(
                        documentId: widget.documentId,
                        details: 'nothing',
                      ) // access received documetId
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                onPressed: () async {
                  //for localStorage
                  var sharePref = await SharedPreferences.getInstance();
                  int count = 1;
                  // print(_count.toString());
                  //_user = FirebaseAuth.instance.currentUser;
                  // Handle the input data here (e.g., add to Firestore)
                  var collection =
                      FirebaseFirestore.instance.collection('serialList');
                  var total;
                  var limit;
                  var activity;
                  collection.doc(widget.documentId).get().then((documentSnapshot) {
                    if (documentSnapshot.exists) {
                      print("documentSnapshot");
                      //array,serial_list length
                      count = documentSnapshot.data()?['name'].length;
                      total = documentSnapshot.data()?['total'];
                      limit = documentSnapshot.data()?['limit'];
                      activity = documentSnapshot.data()?['activity'];
                    }
                  }).then((value) {
                    print("activity : $activity");
                    print("$total + 1  $limit");
                    if (total + 1 <= limit && activity) {
                      var data = collection.doc(widget.documentId); // <-- Document ID
                      data.set({
                        'name': FieldValue.arrayUnion([userName])
                      }, SetOptions(merge: true));
                      data.set({'total': count + 1}, SetOptions(merge: true));
                    } else if (!activity) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.red,
                            content: Center(
                              child: Text("Shop already Closed"),
                            )),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.red,
                            content: Center(
                              child: Text("Limit Exceeded"),
                            )),
                      );
                    }
                  });

                 // Navigator.of(context).pop();
                },
                // onPressed: () {
                //   var user = FirebaseAuth.instance.currentUser;
                //   // Handle the input data here (e.g., add to Firestore)
                //   var collection =
                //       FirebaseFirestore.instance.collection('serialList');
                //   var data = collection
                //       .doc(widget.documentId)
                //   var doc = collection
                //       .doc(widget.documentId) // <-- Document ID
                //       .set({
                //     'name': FieldValue.arrayUnion([_user!.displayName])
                //   }, SetOptions(merge: true)) // <-- Add data
                //       .then((value) {
                //     print('Added');
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //           backgroundColor: Colors.green,
                //           content: Center(
                //             child: Text("Added Successfully"),
                //           )),
                //     );
                //   }).catchError((error) {
                //     print('Add failed: $error');
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //           backgroundColor: Colors.red,
                //           content: Center(
                //             child: Text("Something Wrong"),
                //           )),
                //     );
                //   });
                // },
                child: Icon(Icons.hail),
              )
            ],
          ),
        ));
  }

  void _fetchFromLocalStorage() async {
    var sharePref = await SharedPreferences.getInstance();
    userName = sharePref.getString(SplashPageState.USERNAME)!;
    // setState(() {
    //   appBar = userName!;
    // });
  }
}
