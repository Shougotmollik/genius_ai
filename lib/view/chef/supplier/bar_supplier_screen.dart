import 'package:flutter/material.dart';

class BarSupplierScreen extends StatefulWidget {
  const BarSupplierScreen({super.key});

  @override
  State<BarSupplierScreen> createState() => _BarSupplierScreenState();
}

class _BarSupplierScreenState extends State<BarSupplierScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("bar Supplier Screen")));
  }
}
