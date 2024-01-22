import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SerialDetail extends StatelessWidget {
  final String documentId; // Accept the document ID as a parameter

  SerialDetail({required this.documentId});
  //const SerialDetail({super.key, required this.documentId});



  @override
  Widget build(BuildContext context) {
    var role;
    // finding the role of the users
    FirebaseFirestore.instance.collection('users').doc(documentId).get()
    .then((DocumentSnapshot documentSnapshot){
      role = documentSnapshot['role'];
    });

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('serialList').doc(documentId).snapshots(),
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
              // decoration: BoxDecoration(
              //   //borderRadius: BorderRadius.circular(20),
              //   //color: Colors.white,
              // ),
              child: Card(
                child: ListTile(
                  title: Text(
                    array[index].toString(),
                      style:titleTextStyle,
                  ),
                  // tileColor: Colors.greenAccent,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(20),
                  // ),

                  contentPadding: EdgeInsets.all(5),
                  titleTextStyle: titleTextStyle,
                trailing: role == "ServiceProvider"?
                    ElevatedButton.icon(
                      onPressed: (){
                        var val = [];
                        val.add(array[index].toString());
                        final collection = FirebaseFirestore.instance.collection('serialList');
                        collection.doc(documentId)
                        .update({
                          'name' : FieldValue.arrayRemove(val),
                        });
                      },
                      icon: Icon(Icons.done), label: Text("Done"))
                      : FilledButton.icon(
                          onPressed:(){},
                          icon: Icon(Icons.timer),
                          label: Text(""),
                ),

                ),
              ),
            );
          },
        );
      },
    );
  }
  void dj(){
    var listCollection = FirebaseFirestore.instance.collection('serialList');


  }
}

