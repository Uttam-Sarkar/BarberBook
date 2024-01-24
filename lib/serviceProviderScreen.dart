import 'package:barberbook/serialDetailsList.dart';
import 'package:barberbook/serviceProviderSettings.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchFromLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBar),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_outlined),
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ServiceProviderSettings()));
            }
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

  void _fetchFromLocalStorage() async {
    var sharePref = await SharedPreferences.getInstance();
    var storeName = sharePref.getString(SplashPageState.STORENAME);
    setState (() {
      appBar = storeName!;

    });
  }
}
