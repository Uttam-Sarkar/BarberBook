import 'package:barberbook/login.dart';
import 'package:barberbook/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceProviderSettings extends StatefulWidget {
  const ServiceProviderSettings({super.key});

  @override
  State<ServiceProviderSettings> createState() => _ServiceProviderSettingsState();
}

class _ServiceProviderSettingsState extends State<ServiceProviderSettings> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchFromLocalStorage();
  }

  String userName = "Service Provider";
  String phone = "Null";
  String email = "Null";
  String storeName = "Store";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Text(
                "Store Name : $storeName",
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20,),
              Text(
                "Name : $userName",
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Phone : $phone",
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Email : $email",
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    _showEditPopUp(context);
                  },

                  child: const Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.green,
                      shadows: [
                        Shadow(
                          color: Colors.black87, // Choose the color of the shadow
                          blurRadius:
                          2.0, // Adjust the blur radius for the shadow effect
                          offset: Offset(2.0,
                              2.0), // Set the horizontal and vertical offset for the shadow
                        ),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 100,
              ),

              //           FirebaseAuth.instance.signOut().then((value){
              // print('Log out.');
              // Navigator.push(context, MaterialPageRoute(builder: (context) => MyLogin()));
              //
              ElevatedButton(
                  onPressed: () async {
                    var sharePref = await SharedPreferences.getInstance();
                    sharePref.setBool(SplashPageState.KEYLOGIN, false );
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => const MyLogin()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.red,
                            content: Center(
                              child: Text("Logged out Successfully"),
                            )
                        ),
                      );

                    });
                  },
                  child: const Text(
                    "Log Out",
                    style: TextStyle(fontSize: 25, color: Colors.redAccent),
                  ))
            ],
          ),
        ));
  }

  Future<void> _fetchFromLocalStorage() async {
    //var sharePref = await SharedPreferences.getInstance();

    User? user = FirebaseAuth.instance.currentUser;
    var kk = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {

        userName = documentSnapshot.get(SplashPageState.USERNAME);
        storeName = documentSnapshot.get(SplashPageState.STORENAME);
        phone = documentSnapshot.get(SplashPageState.PHONE);
        email = documentSnapshot.get(SplashPageState.EMAIL);

      }});
    setState(() {


    });
  }
  // userName = sharePref.getString(SplashPageState.USERNAME)!;
  // phone = sharePref.getString(SplashPageState.PHONE)!;
  // email = sharePref.getString(SplashPageState.EMAIL)!;

  void _showEditPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // String inputText = "Customer";
        // String name = "user";
        // //  int _count = 0;

        return AlertDialog(

          title: const Text('Give Information'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    obscureText: false,
                    initialValue: storeName,
                    decoration: const InputDecoration(labelText: "Store Name",icon: Icon(Icons.storefront)),
                    onChanged: (text){
                      storeName = text;
                    },
                  ),
                  TextFormField(
                    obscureText: false,
                    initialValue: userName,
                    decoration: const InputDecoration(labelText: "Name",icon: Icon(Icons.account_box)),
                    onChanged: (text){
                      userName = text;
                    },
                  ),
                  TextFormField(
                    obscureText: false,
                    initialValue: phone,
                    decoration: const InputDecoration(labelText: "Phone",icon: Icon(Icons.call)),
                    onChanged: (text){
                      phone = text;
                    },
                  ),
                  TextFormField(

                    obscureText: false,
                    initialValue: email,
                    decoration: const InputDecoration(labelText: "Email(Not Changeable)",icon: Icon(Icons.email_outlined)),
                    // onChanged: (text){
                    //   email = text;
                    // },
                  ),

                ],
              ),
            ),
          ),


          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                var sharePref = await SharedPreferences.getInstance();
                sharePref.setString(SplashPageState.STORENAME, storeName );
                sharePref.setString(SplashPageState.USERNAME, userName );
                sharePref.setString(SplashPageState.PHONE, phone );
                // sharePref.setString(SplashPageState.EMAIL, email );

                var user = FirebaseAuth.instance.currentUser;
                CollectionReference ref = FirebaseFirestore.instance.collection('users');
                ref.doc(user!.uid).update({
                  SplashPageState.USERNAME : userName,
                  SplashPageState.PHONE: phone,
                  SplashPageState.EMAIL: email,
                  SplashPageState.STORENAME : storeName,
                });
                setState(() {

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
