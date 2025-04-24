import 'package:flutter/material.dart';

void main() {
  runApp(ReverseNumberApp());
}

class ReverseNumberApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reverse Number',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: ReverseNumberHome(),
    );
  }
}

class ReverseNumberHome extends StatefulWidget {
  @override
  _ReverseNumberHomeState createState() => _ReverseNumberHomeState();
}

class _ReverseNumberHomeState extends State<ReverseNumberHome> {
  final TextEditingController _controller = TextEditingController();
  String _reversed = '';

  void _reverseNumber() {
    String input = _controller.text;
    if (input.isEmpty || int.tryParse(input) == null) {
      setState(() {
        _reversed = 'Please enter a valid number';
      });
      return;
    }

    int number = int.parse(input);
    int reversed = 0;
    while (number != 0) {
      int digit = number % 10;
      reversed = reversed * 10 + digit;
      number ~/= 10;
    }

    setState(() {
      _reversed = reversed.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reverse a Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter a number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _reverseNumber,
              child: Text('Reverse'),
            ),
            SizedBox(height: 20),
            Text(
              'Reversed: $_reversed',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
