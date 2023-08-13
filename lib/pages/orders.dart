import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app/colors.dart';
import 'package:store_app/gets/get_price.dart';
import 'package:store_app/gets/get_url.dart';
import '../gets/get_name.dart';

class order extends StatefulWidget {
  const order({super.key});

  @override
  State<order> createState() => _ordertState();
}

class _ordertState extends State<order> {
  final namecontroller = TextEditingController();
  final pricecontroller = TextEditingController();
  List<String> docsid = [];

  Future<List<String>> getdocsid() async {
    final snapshot = await FirebaseFirestore.instance.collection('order').get();
    return snapshot.docs.map((document) => document.reference.id).toList();
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('product')
          .doc(productId)
          .delete();
      print('Product deleted successfully!');
      setState(() {
        // Reload the list view after deleting the product
      });
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(19.0),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "  Your orders",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: FutureBuilder<List<String>>(
                  future: getdocsid(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      docsid = snapshot.data!;
                      return ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Divider(
                              color: Color(0xFFDDAF92),
                              thickness: 1.0,
                              height: 1.0,
                            ),
                          );
                        },
                        itemCount: docsid.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: darker,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text("info")),
                            subtitle: getpricee(Documentid: docsid[index]),
                            title: getitt(Documentid: docsid[index]),
                            leading: get_urll(Documentid: docsid[index]),
                          );
                        },
                      );
                    }
                    return Text("No data available.");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
