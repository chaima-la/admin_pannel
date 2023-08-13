import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:store_app/colors.dart';
import 'package:store_app/pages/orders.dart';
import 'package:store_app/pages/product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  List<String> docsid = [];

  final List<Widget> _screens = [
    Product(),
    Product(),
    order(),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: background,
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: darker,
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment),
                label: 'Statistic',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.playlist_add_check),
                label: 'Orders',
              ),
            ],
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.store,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "   Store",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          body: _screens[_currentIndex]),
    );
  }
}
