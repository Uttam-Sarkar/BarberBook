import 'package:barberbook/serialDetailsList.dart';
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
        title: Text("Shop Name"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_outlined),
            onPressed: (){}
          ),
        ],
        leading: CircleAvatar(
          backgroundColor: Colors.black45,
        ),
        backgroundColor: Colors.orange,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)
          )
        ),
      ),


      body: SingleChildScrollView(
        child: Column(
          children: [
            //Text((add(1, 1)).toString()),
            Container(
              height: 50,
                color: Colors.green,
                width: double.infinity,
                child: Text("OPTION")),
            SizedBox(height: 10,),
            Container(
              height: 500,
              width: double.infinity,
              color: Colors.grey.shade400,
              padding: EdgeInsets.all(10),
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
