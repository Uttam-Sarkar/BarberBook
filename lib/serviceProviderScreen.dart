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
        leading: const CircleAvatar(
          child: Icon(Icons.person),
          backgroundColor: Colors.black45,
        ),
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
        //backgroundColor: Colors.orange,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(10),
        //     bottomRight: Radius.circular(10)
        //   )
        // ),
      ),


      body: SingleChildScrollView(
        child: Column(
          children: [
            //Text((add(1, 1)).toString()),
            const SizedBox(height: 30,),
            Container(
              height: 50,
                color: Colors.green,
                width: double.infinity,
                child: Text("OPTION")),
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
                child: user!.uid.isNotEmpty ?
                SerialDetail(documentId: '${user?.uid}',)
                : const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            const SizedBox(height: 5,),
            Container(
               height: 100,
              width: double.infinity,
              // from addSerial.dart
              child: PopUp(),
            ),
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
