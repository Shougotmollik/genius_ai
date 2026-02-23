import 'package:flutter/material.dart';

class BarUploadScreen extends StatefulWidget {
  const BarUploadScreen({super.key});

  @override
  State<BarUploadScreen> createState() => _BarUploadScreenState();
}

class _BarUploadScreenState extends State<BarUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("bar Upload Screen")));
  }
}
