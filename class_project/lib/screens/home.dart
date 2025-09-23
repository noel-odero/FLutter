import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Last App on Earth"),
        backgroundColor: Colors.grey,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Going to Mars Tomorrow!",
            style: TextStyle(
              color: Colors.red,
              fontSize: 50.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset('assets/Noel.jpg', height: 300, width: 300),
          Text('Noel'),
        ],
      ),
    );
  }
}
