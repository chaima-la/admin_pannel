import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app/colors.dart';
import 'package:store_app/gets/get_price.dart';
import 'package:file_picker/file_picker.dart';
import 'package:store_app/gets/get_url.dart';
import '../gets/get_name.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final namecontroller = TextEditingController();
  final pricecontroller = TextEditingController();
  List<String> docsid = [];
  File? _pickedImage;
  String? _uploadedImageUrl;

  Future<void> _uploadImageToFirebase() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      _pickedImage = File(result.files.single.path!);
    });

    if (_pickedImage != null) {
      final fileName = _pickedImage!.path.split('/').last;
      final firebaseStorageRef =
          FirebaseStorage.instance.ref().child('images/$fileName');
      final uploadTask = firebaseStorageRef.putFile(_pickedImage!);

      final taskSnapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Add the new image URL to Firestore
      await FirebaseFirestore.instance.collection('images').add({
        'url': imageUrl,
      });
      setState(() {
        _uploadedImageUrl = imageUrl;
      });
    }
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      _pickedImage = File(result.files.single.path!);
    });
  }

  Future<void> addProductWithImage() async {
    if (_pickedImage == null) {
      // Handle the case where no image is picked (optional).
      return;
    }

    // Upload the image to Firebase Storage
    final fileName = _pickedImage!.path.split('/').last;
    final firebaseStorageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/$fileName');
    final uploadTask = firebaseStorageRef.putFile(_pickedImage!);
    final taskSnapshot = await uploadTask.whenComplete(() => null);
    final imageUrl = await taskSnapshot.ref.getDownloadURL();

    // Add the new product data with image URL to Firestore
    final CollectionReference productCollection =
        FirebaseFirestore.instance.collection('product');
    await productCollection.add({
      'name': namecontroller.text,
      'price': pricecontroller.text,
      'image_url': imageUrl, // Add the image URL to the product data
    });

    // Clear input fields and update the UI with the new list of products
    namecontroller.clear();
    pricecontroller.clear();
    _pickedImage = null;
    setState(() {});
  }

  Future<List<String>> getdocsid() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('product').get();
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
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  "Edit products",
                  style: TextStyle(
                    fontSize: 38,
                    //   color: Color.fromARGB(255, 237, 237, 237),
                  ),
                ),
              ),
              SizedBox(
                height: 55,
              ),
              Text("add new product"),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: namecontroller,
                decoration: InputDecoration(
                  hintText: "name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFDDAF92)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: pricecontroller,
                decoration: InputDecoration(
                  hintText: "price",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFDDAF92)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "add your img",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                    onPressed: () {
                      pickImage();
                    },
                    icon: Icon(Icons.camera_alt),
                  ),
                ],
              ),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(darker),
                  ),
                  onPressed: addProductWithImage, // Call addProduct function
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "add to list",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
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
                            subtitle: getprice(Documentid: docsid[index]),
                            title: getit(Documentid: docsid[index]),
                            leading: get_url(Documentid: docsid[index]),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Confirm Delete'),
                                      content: Text(
                                          'Are you sure you want to delete this product?'),
                                      actions: [
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        TextButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            // Call the deleteProduct function when the user confirms deletion
                                            deleteProduct(docsid[index]);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
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
