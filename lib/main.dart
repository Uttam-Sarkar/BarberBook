import 'dart:async';
//import 'dart:js';
import 'package:barberbook/firebase_options.dart';
import 'package:barberbook/serviceProviderScreen.dart';
import 'package:barberbook/userScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

Future<void> main() async {
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
      home:const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => SplashPageState();
}

//_SplashPageStateState eta private.. '_' na thakle static
class SplashPageState extends State<SplashPage> {
  static const String KEYLOGIN = "login";
  static const String ROLE = "role";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Timer(Duration(seconds: 5), () {
    //   Navigator.pushReplacement(context,
    //   MaterialPageRoute(builder: (context) => MyLogin()));
    // });
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child:Icon(Icons.account_circle, color: Colors.white,),
      ),
    );
  }

  void whereToGo() async {
    var sharePref = await SharedPreferences.getInstance();

    var isLoggedIn = sharePref.getBool(KEYLOGIN);
    var role = sharePref.getString(ROLE);

    Timer(Duration(seconds: 2),() {
        if (isLoggedIn != null && role != null ) {
          if (isLoggedIn) {
            //role base log in
            if (role == "ServiceProvider") {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(
                    builder: (context) => ServiceProviderScreen(),
                  ));
            } else {
              Navigator.pushReplacement( context,
                  MaterialPageRoute(
                    builder: (context) => UserScreen(),
                  ));
            }
          } else {
            Navigator.pushReplacement( context,
                MaterialPageRoute(
                  builder: (context) => MyLogin(),
                ));
          }
        } else{
          Navigator.pushReplacement( context,
              MaterialPageRoute(
                builder: (context) => MyLogin(),
              ));
        }
      },
    );
  }
}
