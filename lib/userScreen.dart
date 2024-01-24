import 'package:barberbook/shopInfo4User.dart';
import 'package:barberbook/userSettings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'getSerialList.dart';
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
          title: const Text("User Name"),
          centerTitle: false,
          actions: [
            IconButton(
                icon: const Icon(Icons.menu_outlined),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const UserSettings()));
                }
            ),
          ],
          leading: const CircleAvatar(
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

              Container(
                height: 50,
                width: double.infinity,
                color: Colors.red,
                child: Text("Uttam"),
              ),
              Container(
                height: 500,
                color: Colors.cyanAccent.shade100,
                child: _nearestShops != null
                ?ListView.builder(

                  itemCount: _nearestShops?.length,
                  itemBuilder: (context, index) {
                    final shop = _nearestShops?[index];
                    return Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(20),
                      //   color: Colors.indigo.shade200,
                      //   border: Border.all(width: 20)
                      // ),
                      child: Card(
                        child: ListTile(
                          title: Text(shop!['name']),
                          subtitle: Text(
                            //"Latitude: ${shop?['latitude']} | ${shop?.id}| Longitude: ${shop?['longitude']} | Distance: ${_calculateDistance(shop?['latitude'], shop?['longitude'], _currentPosition!.latitude, _currentPosition!.longitude).toStringAsFixed(2)} meters ",
                              "Distance: ${_calculateDistance(shop?['latitude'], shop?['longitude'], _currentPosition!.latitude, _currentPosition!.longitude).toStringAsFixed(2)} meters",
                          ),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            print(shop!.id);
                            Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => ShopInfo4User(documentId: shop!.id, shopName: shop!['name'],),
                              ),
                            );
                          },
                        ),
                      ),
                    );

                  },
                ): Center(
                  child: ElevatedButton(onPressed: (){
                    _fetchLocation();
                  },child: const Text("Nearest Available Shops"),), // Show loading indicator while fetching data
                ),
              ),
            ],
          ),
        ),
    );
  }
}
