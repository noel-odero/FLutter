import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: "Gesture detector"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int numOfTaps = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gesture Detector'), centerTitle: true),
      body: Column(
        children: [
          Text('Tapped $numOfTaps times'),
          GestureDetector(
            onTap: () {
              setState(() {
                numOfTaps++;
              });
            },
            child: Container(
              padding: EdgeInsets.all(15),
              color: Colors.green[200],
              child: Text('Tap here', style: TextStyle(fontSize: 39)),
            ),
          ),
        ],
      ),
    );
  }
}
