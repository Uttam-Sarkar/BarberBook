import 'dart:async';

import 'package:barberbook/serialDetailsList.dart';
import 'package:barberbook/serviceProviderSettings.dart';
import 'package:barberbook/switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addSerial.dart';
import 'main.dart';

class ServiceProviderScreen extends StatefulWidget {
  const ServiceProviderScreen({super.key});

  @override
  State<ServiceProviderScreen> createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  // for app Bar
  String appBar = '';
  var user = FirebaseAuth.instance.currentUser;
  var collection = FirebaseFirestore.instance.collection('serialList');
  //var total = SerialDetail(documentId: user!.uid, details: 'nothing',);

  @override
  void initState() {
    super.initState();
    _fetchFromLocalStorage();

    //findTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
          backgroundColor: Colors.black45,
        ),
        title: Text(appBar),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.menu_outlined),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ServiceProviderSettings()));
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Text((add(1, 1)).toString()),
            const SizedBox(
              height: 20,
            ),
            Container(
                //height: 50,
                //color: Colors.green,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Text("Total : ",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54)),
                        SerialDetail(documentId: user!.uid, details: 'total'),
                      ],
                    ),
                    Row(
                      children: [
                         Text(
                          "Limit : ",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        SerialDetail(documentId: user!.uid, details: 'limit'),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_upward))
                      ],
                    ),
                    const SwitchScreen(),
                  ],
                )),
            // SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
                child: user!.uid.isNotEmpty
                    ? SerialDetail(
                        documentId: '${user?.uid}',
                        details: 'nothing',
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 100,
              width: double.infinity,
              // from addSerial.dart
              child: const AddSerial(),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchFromLocalStorage() async {
    var sharePref = await SharedPreferences.getInstance();
    var storeName = sharePref.getString(SplashPageState.STORENAME);
    setState(() {
      appBar = storeName!;
    });
  }

  // String findTotal() {
  //  // var e = user?;
  //   collection.doc(user!.uid).get().then((documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       total = documentSnapshot.data()?['total'];
  //     }
  //   });
  //   return total.toString();
  // }
}
