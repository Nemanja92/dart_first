import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'prompt.dart';
import 'control.dart';
import 'score.dart';
import 'gamemodel.dart';
import 'dart:math';

void main() => runApp(BullsEyeApp());

class BullsEyeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      title: 'BullsEye',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GamePage(title: 'BullsEye'),
    );
  }
}

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _alertIsVisible = false;
  GameModel _model;

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
            FlatButton(
              child: Text('Hit Me!', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                this._alertIsVisible = true;
                _showAlert(context);
                print("button pressed");
              },
            ),
            Score(totalScore: _model.totalScore, round: _model.round),
          ],
        ),
      ),
    );
  }

  int _sliderValue() => _model.current;

  int _pointsForCurrentRound() {
    var maximumScore = 100;
    var difference = (_model.target - _sliderValue()).abs();
    return maximumScore - difference;
  }

  void _showAlert(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("Awesome!"),
      onPressed: () {
        Navigator.of(context).pop();
        this._alertIsVisible = false;
        print("Awesome pressed! $_alertIsVisible");
      },
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Hello There"),
            content: Text("The slider's value is ${_sliderValue()}.\n" +
                "You scored ${_pointsForCurrentRound()} points this round."),
            actions: <Widget>[
              okButton,
            ],
            elevation: 5,
          );
        });
  }
}
