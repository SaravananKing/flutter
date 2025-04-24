import 'package:flutter/material.dart';

void main() => runApp(SimpleCalculator());

class SimpleCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String expression = '';
  String input = '';
  double num1 = 0;
  String operator = '';
  String result = '';

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        result = '';
        expression = '';
        num1 = 0;
        operator = '';
      } else if (value == '+' || value == '-' || value == '×' || value == '÷') {
        if (input.isNotEmpty) {
          num1 = double.parse(input);
          operator = value;
          expression = input + operator;
          input = '';
        }
      } else if (value == '=') {
        if (input.isNotEmpty && operator.isNotEmpty) {
          double num2 = double.parse(input);
          double res = 0;
          if (operator == '+') res = num1 + num2;
          else if (operator == '-') res = num1 - num2;
          else if (operator == '×') res = num1 * num2;
          else if (operator == '÷') res = (num2 != 0) ? num1 / num2 : 0;

          result = res.toString();
          expression = '$num1$operator$num2';
          input = result;
          operator = '';
        }
      } else {
        input += value;
        expression += value;
      }
    });
  }

  Widget buildButton(String text) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => buttonPressed(text),
        child: Text(text, style: TextStyle(fontSize: 24)),
        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expression Calculator')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(24),
              child: Text(
                expression,
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(right: 24, bottom: 12),
            child: Text(
              result,
              style: TextStyle(fontSize: 24, color: Colors.grey),
            ),
          ),
          Column(
            children: [
              Row(children: [buildButton('7'), buildButton('8'), buildButton('9'), buildButton('÷')]),
              Row(children: [buildButton('4'), buildButton('5'), buildButton('6'), buildButton('×')]),
              Row(children: [buildButton('1'), buildButton('2'), buildButton('3'), buildButton('-')]),
              Row(children: [buildButton('0'), buildButton('.'), buildButton('='), buildButton('+')]),
              Row(children: [buildButton('C')]),
            ],
          )
        ],
      ),
    );
  }
}
