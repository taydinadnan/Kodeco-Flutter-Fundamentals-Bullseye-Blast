import 'dart:math';

import 'package:bullseye/control.dart';
import 'package:bullseye/game_model.dart';
import 'package:bullseye/prompt.dart';
import 'package:bullseye/score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const BullsEyeApp());
}

class BullsEyeApp extends StatelessWidget {
  const BullsEyeApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return const MaterialApp(
      title: 'Bullseye',
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late GameModel _model;

  @override
  void initState() {
    super.initState();
    _model = GameModel(Random().nextInt(100) + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Prompt(targetValue: _model.target),
            Control(model: _model),
            TextButton(
              onPressed: () {
                _showAlert(context);
                setState(() {
                  _model.totalScore += _pointsForCurrentRound();
                });
              },
              child: const Text(
                'Hit Me!',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            Score(
              totalScore: _model.totalScore,
              round: _model.round,
            )
          ],
        ),
      ),
    );
  }

  int _pointsForCurrentRound() {
    const maximumScore = 100;

    ///calculate the difference with abs(absolute value)
    var difference = (_model.target - _model.current).abs();

    ///calculate the value with if statement
    // int difference;
    // if (_model.current > _model.target) {
    //   difference = _model.current - _model.target;
    // } else if (_model.target > _model.current) {
    //   difference = _model.target - _model.current;
    // } else {
    //   difference = 0;
    // }
    return maximumScore - difference;
  }

  void _showAlert(BuildContext context) {
    var okButton = TextButton(
        child: const Text("Awesome!"),
        onPressed: () {
          Navigator.of(context).pop();
        });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hello there!"),
          content: Text('The slider\'s value is ${_model.current}.\n'
              'You scored ${_pointsForCurrentRound()} points this round.'),
          actions: [
            okButton,
          ],
          elevation: 5,
        );
      },
    );
  }
}
