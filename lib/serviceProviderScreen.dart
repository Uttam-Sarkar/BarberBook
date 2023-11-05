import 'package:barberbook/serialDetailsList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'addSerial.dart';

class ServiceProviderScreen extends StatefulWidget {
  const ServiceProviderScreen({super.key});

  @override
  State<ServiceProviderScreen> createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  var user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ServiceProvider"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
                color: Colors.green,
                width: double.infinity,
                child: Text("OPTION")),
            SizedBox(height: 10,),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.red,
              child: user!.uid.isNotEmpty ?
              SerialDetail(documentId: '${user?.uid}',)
              : Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Container(
              height: 100,
              width: double.infinity,
              child: PopUp(),
            )
          ],
        ),
      ),
    );
  }
}
