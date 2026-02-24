import 'package:flutter/material.dart';

class RestaurantProfileScreen extends StatefulWidget {
  const RestaurantProfileScreen({super.key});

  @override
  State<RestaurantProfileScreen> createState() => _RestaurantProfileScreenState();
}

class _RestaurantProfileScreenState extends State<RestaurantProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Restaurant Profile Screen")));
  }
}
