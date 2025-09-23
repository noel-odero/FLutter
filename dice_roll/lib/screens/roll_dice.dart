import 'package:flutter/material.dart';
import 'dart:math';

class RollDice extends StatefulWidget {
  const RollDice({super.key});

  @override
  State<RollDice> createState() => _RollDiceState();
}

class _RollDiceState extends State<RollDice> {
  int defaultDiceNumber = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Let's Play",
              style: TextStyle(color: Colors.white, fontSize: 25.0),
            ),
            Image.asset('assets/dice-$defaultDiceNumber.png'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  defaultDiceNumber = Random().nextInt(6) + 1;
                  print(defaultDiceNumber);
                });
              },
              child: Text('Roll Dice'),
            ),
          ],
        ),
      ),
    );
  }
}
