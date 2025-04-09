import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: QuizScreen(),
));

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> _questions = [
    {
      "question": "What is the capital of France?",
      "options": ["Berlin", "Madrid", "Paris", "Lisbon"],
      "answer": "Paris"
    },
    {
      "question": "Which planet is known as the Red Planet?",
      "options": ["Earth", "Mars", "Jupiter", "Saturn"],
      "answer": "Mars"
    },
    {
      "question": "What is 2 + 2?",
      "options": ["3", "4", "5", "6"],
      "answer": "4"
    }
  ];

  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timer = 10;
  late Timer _questionTimer;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _questionTimer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = 10;
    _questionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timer > 0) {
        setState(() {
          _timer--;
        });
      } else {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    _questionTimer.cancel();
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _answered = false;
        _startTimer();
      } else {
        _showScore();
      }
    });
  }

  void _checkAnswer(String selectedOption) {
    if (!_answered) {
      _questionTimer.cancel();
      setState(() {
        _answered = true;
        if (selectedOption == _questions[_currentQuestionIndex]['answer']) {
          _score++;
        }
      });
      Future.delayed(Duration(seconds: 2), _nextQuestion);
    }
  }

  void _showScore() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("Quiz Completed"),
        content: Text("Your score: $_score / ${_questions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentQuestionIndex = 0;
                _score = 0;
                _answered = false;
                _startTimer();
              });
            },
            child: Text("Restart"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var question = _questions[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(title: Text("Quiz App")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Time Left: $_timer s",
              style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              question['question'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ...question['options'].map<Widget>((option) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  child: Text(option, style: TextStyle(fontSize: 20)),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
