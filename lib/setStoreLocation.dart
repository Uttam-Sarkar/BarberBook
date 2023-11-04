import 'package:barberbook/serviceProviderScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'locationPermission.dart';
import 'package:firebase_core/firebase_core.dart';


class SetStoreLocation extends StatefulWidget {
  const SetStoreLocation({super.key});

  @override
  State<SetStoreLocation> createState() => _SetStoreLocationState();
}

class _SetStoreLocationState extends State<SetStoreLocation> {
  final LocationService locationService = LocationService();
  Position? _currentPosition;
  String _locationMessage = "";
  Future<void> _fetchLocation() async {
    final Position position = await locationService.getLocation();
    try {

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];

      setState(() {
        _currentPosition = position;
        _locationMessage = "${place.name}, ${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
      setState(() {
        _locationMessage = "Error getting location data.";
      });
    }
    // Use the location data as needed.
  }
  void initState() {
    super.initState();
    _fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Set Store Location"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1,
              right: 35,
              left: 35),
          child: Column(

            children:[
              if(_currentPosition != null)
                Column(
                    children:[
                      Text("Your Location Name",style: TextStyle(color: Colors.blue, fontSize: 35),),
                      Text(_locationMessage, style: TextStyle(color: Colors.redAccent, fontSize: 20),),
                    ]
                ),
              // Text("data"),

              // SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: _fetchLocation,
              //   child: Text("Get Location"),
              // ),
              SizedBox(height: 40,),
              ElevatedButton(
                  onPressed: () async {
                    try{
                      final locationDetails = FirebaseFirestore.instance.collection('locationDetails');
                      var user = FirebaseAuth.instance.currentUser;
                      await locationDetails.doc(user!.uid).set({
                        'latitude' : _currentPosition!.latitude,
                        'longitude' : _currentPosition!.longitude,
                      });
                      print('Created new account.');
                      // Successfully notification
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.green,
                            content: Center(
                              child: Text("Save Location Successfully"),
                            )
                        ),
                      );
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=> ServiceProviderScreen()));
                    }catch (error){
                      print("Error ${error.toString()}");
                      // error Notification
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.red,
                            content: Center(
                              child: Text("There found a problem"),
                            )
                        ),
                      );

                    }

                  },
                  child: Text("Set as Store Location")),
            ],
          ),
        ),
      ),
    );
  }
}
