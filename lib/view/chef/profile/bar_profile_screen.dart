import 'package:flutter/material.dart';

class BarProfileScreen extends StatefulWidget {
  const BarProfileScreen({super.key});

  @override
  State<BarProfileScreen> createState() => _BarProfileScreenState();
}

class _BarProfileScreenState extends State<BarProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("bar Profile Screen")));
  }
}
