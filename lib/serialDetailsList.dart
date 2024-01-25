import 'package:barberbook/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SerialDetail extends StatefulWidget {
  final String documentId; // Accept the document ID as a parameter

  SerialDetail({required this.documentId});

  @override
  State<SerialDetail> createState() => _SerialDetailState();
}


class _SerialDetailState extends State<SerialDetail> {
  var role;

  //const SerialDetail({super.key, required this.documentId});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchFromLocalStorage();
  }
  @override
  Widget build(BuildContext context) {

    // finding the role of the users
    // var role = SplashPageState.Role;
    // role = sharePref.getString(SplashPageState.USERNAME)
    // FirebaseFirestore.instance.collection('users').doc(widget.documentId).get()
    // .then((DocumentSnapshot documentSnapshot){
    //   role = documentSnapshot['role'];
    // });

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('serialList').doc(widget.documentId).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Text('No data available');
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;
        List<dynamic> array = data['name'];

        if (array.isEmpty) {
          return Text('No data available');
        }

        return ListView.builder(
          itemCount: array.length,
          itemBuilder: (context, index) {
            final TextStyle titleTextStyle = index.isEven
                ? TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.brown)
                : TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black);
            return Container(
              //distance between two tile
              padding: const EdgeInsetsDirectional.only(bottom: 5),
              // decoration: BoxDecoration(
              //   //borderRadius: BorderRadius.circular(20),
              //   //color: Colors.white,
              // ),
              child: Card(
               // semanticContainer: true,
                elevation:10,
                //color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                shadowColor: Colors.red,

                child: ListTile(
                  leading: CircleAvatar(
                      child: Text('${index+1}',
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )
                  ),
                  title: Text(
                    array[index].toString(),
                      style:titleTextStyle,
                  ),
                  // tileColor: Colors.greenAccent,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(20),
                  // ),

                  contentPadding: const EdgeInsets.all(10),
                  titleTextStyle: titleTextStyle,
                trailing: role == "ServiceProvider"?
                    ElevatedButton.icon(
                      onPressed: (){
                        var val = [];
                        val.add(array[index].toString());
                        final collection = FirebaseFirestore.instance.collection('serialList');
                        collection.doc(widget.documentId)
                        .update({
                          'name' : FieldValue.arrayRemove(val),
                        });
                      },
                      label: const Text("Done"),
                      icon: const Icon(Icons.done,),  )
                      : FilledButton.icon(
                          onPressed:(){},
                          icon: const Icon(Icons.timer),
                          label: const Text(""),
                ),

                ),
              ),
            );
          },
        );
      },
    );
  }

  // void dj(){
  //   var listCollection = FirebaseFirestore.instance.collection('serialList');
  //
  // }

  Future<void> _fetchFromLocalStorage() async {
    //finding the role of the users
    var sharePref = await SharedPreferences.getInstance();
    role = sharePref.getString(SplashPageState.ROLE);
  }
}

