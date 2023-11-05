import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SerialDetail extends StatelessWidget {
  final String documentId; // Accept the document ID as a parameter

  SerialDetail({required this.documentId});
  //const SerialDetail({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
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
        List<dynamic> array = data['lists'];

        return ListView.builder(
          itemCount: array.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(array[index].toString()),
            );
          },
        );
      },
    );
  }
}

