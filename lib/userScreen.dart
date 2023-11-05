import 'package:barberbook/getNearestShops.dart';
import 'package:barberbook/setStoreLocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'locationPermission.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final LocationService locationService = LocationService();
  Position? _currentPosition;
  List<DocumentSnapshot>? _nearestShops ;
  // DocumentSnapshot<Object?> shopSnapshot = _nearestShops as DocumentSnapshot<Object?>; // Your DocumentSnapshot


  Future<void> _fetchLocation() async {
    final Position position = await locationService.getLocation();
    try{
      setState(() {
        _currentPosition = position;
      });

      // 30 Nearest Shop
      setState(() async {
        _nearestShops = await getNearestShops(_currentPosition as Position);

      });
    }catch (e){
      print(e);
    }
  }

  double _calculateDistance(double lat1, double long1, double lat2, double long2) {
    // Use the Haversine formula or geolocator to calculate distance
    return Geolocator.distanceBetween(lat1, long1, lat2, long2);
  }

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("User"),
    ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                width: double.infinity,
                color: Colors.red,
                child: Text("Uttam"),
              ),
              Container(
                height: 500,
                color: Colors.cyanAccent,
                child: _nearestShops != null
                ?ListView.builder(
                  itemCount: _nearestShops?.length,
                  itemBuilder: (context, index) {
                    final shop = _nearestShops?[index];
                    return ListTile(
                      title: Text(shop?['name']),
                      subtitle: Text(
                        "Latitude: ${shop?['latitude']} | Longitude: ${shop?['longitude']} | Distance: ${_calculateDistance(shop?['latitude'], shop?['longitude'], _currentPosition!.latitude, _currentPosition!.longitude).toStringAsFixed(2)} meters ",
                      ),
                    );
                  },
                ): Center(
                  child: ElevatedButton(onPressed: (){
                    _fetchLocation();
                  },child: Text("Nearest Available Shops"),), // Show loading indicator while fetching data
                ),
              ),
            ],
          ),
        ),
    );
  }
}
