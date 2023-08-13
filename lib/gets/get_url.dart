import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class get_url extends StatelessWidget {
  final String Documentid;
  get_url({required this.Documentid});

  @override
  Widget build(BuildContext context) {
    CollectionReference names =
        FirebaseFirestore.instance.collection('product');
    return FutureBuilder<DocumentSnapshot>(
        future: names.doc(Documentid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return CircleAvatar(
              backgroundImage: NetworkImage("${data['image_url']}"),
            );
          }
          return Text("loading...");
        });
  }
}

class get_urll extends StatelessWidget {
  final String Documentid;
  get_urll({required this.Documentid});

  @override
  Widget build(BuildContext context) {
    CollectionReference names = FirebaseFirestore.instance.collection('order');
    return FutureBuilder<DocumentSnapshot>(
        future: names.doc(Documentid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return Text("num ${data['num']}");
          }
          return Text("loading...");
        });
  }
}
