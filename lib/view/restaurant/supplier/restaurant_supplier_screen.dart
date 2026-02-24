import 'package:flutter/material.dart';

class RestaurantSupplierScreen extends StatefulWidget {
  const RestaurantSupplierScreen({super.key});

  @override
  State<RestaurantSupplierScreen> createState() => _RestaurantSupplierScreenState();
}

class _RestaurantSupplierScreenState extends State<RestaurantSupplierScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Restaurant Supplier Screen")));
  }
}
