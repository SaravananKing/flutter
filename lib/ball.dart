import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(BouncingBallApp());

class BouncingBallApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flexible Bouncing Ball',
      home: BallScreen(),
    );
  }
}

class BallScreen extends StatefulWidget {
  @override
  _BallScreenState createState() => _BallScreenState();
}

class _BallScreenState extends State<BallScreen> {
  bool useVertical = false; // 👉 Change this to false for horizontal movement

  double _xPos = 0;
  double _yPos = 0;
  bool _movingForward = true;
  Color _ballColor = Colors.blue;
  late double maxBoundary;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 10), _moveBall);
  }

  void _moveBall(Timer timer) {
    setState(() {
      double pos = useVertical ? _yPos : _xPos;

      if (_movingForward) {
        pos += 2;
        if (pos >= maxBoundary - 50) {
          _movingForward = false;
          _changeColor();
        }
      } else {
        pos -= 2;
        if (pos <= 0) {
          _movingForward = true;
          _changeColor();
        }
      }

      if (useVertical) {
        _yPos = pos;
      } else {
        _xPos = pos;
      }
    });
  }

  void _changeColor() {
    _ballColor = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  @override
  Widget build(BuildContext context) {
    maxBoundary = useVertical
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Flexible Bouncing Ball')),
      body: Stack(
        children: [
          Positioned(
            top: useVertical ? _yPos : MediaQuery.of(context).size.height / 2 - 25,
            left: useVertical ? MediaQuery.of(context).size.width / 2 - 25 : _xPos,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _ballColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
