import 'package:barberbook/firebase_options.dart';
import 'package:barberbook/mapNearLocation.dart';
import 'package:barberbook/myLocation.dart';
import 'package:barberbook/register.dart';
import 'package:barberbook/serialDetailsList.dart';
import 'package:barberbook/serviceProviderScreen.dart';
import 'package:barberbook/setStoreLocation.dart';
import 'package:barberbook/userScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'nearDocs.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyLogin(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(child: Text("Serial"),height: 30,color: Colors.red,),
          Container(
            height: 100,
              color: Colors.brown,
              child: SerialDetail(documentId: 'WHyvpBl1iDaMp0ve8YpYQDKKsEn1',)
          ),
        ],
      )
    );
  }
}
