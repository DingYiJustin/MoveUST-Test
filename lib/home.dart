import 'package:flutter/material.dart';
import 'pedometer/Pedometer.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MoveUST"),
        actions: []),
      body: PedoCheck(),
    );
  }
}