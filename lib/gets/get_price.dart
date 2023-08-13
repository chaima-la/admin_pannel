import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class getprice extends StatelessWidget {
  final String Documentid;
  getprice({required this.Documentid});

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
            return Text("the price: ${data['price']}");
          }
          return Text("loading...");
        });
  }
}

class getpricee extends StatelessWidget {
  final String Documentid;
  getpricee({required this.Documentid});

  @override
  Widget build(BuildContext context) {
    CollectionReference names = FirebaseFirestore.instance.collection('order');
    return FutureBuilder<DocumentSnapshot>(
        future: names.doc(Documentid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Text("the price: ${data['price']}");
          }
          return Text("loading...");
        });
  }
}
