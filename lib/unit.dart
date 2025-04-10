import 'package:flutter/material.dart';

void main() => runApp(UnitConverterApp());

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UnitConverterScreen(),
    );
  }
}

class UnitConverterScreen extends StatefulWidget {
  @override
  _UnitConverterScreenState createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _selectedConversion = 'Meters to Kilometers';
  String _result = '';

  final List<String> _conversionOptions = [
    'Meters to Kilometers',
    'Kilometers to Meters',
    'Celsius to Fahrenheit',
    'Fahrenheit to Celsius',
    'Kilograms to Pounds',
    'Pounds to Kilograms',
  ];

  void _convert() {
    double input = double.tryParse(_inputController.text) ?? 0;
    double output;

    switch (_selectedConversion) {
      case 'Meters to Kilometers':
        output = input / 1000;
        break;
      case 'Kilometers to Meters':
        output = input * 1000;
        break;
      case 'Celsius to Fahrenheit':
        output = (input * 9 / 5) + 32;
        break;
      case 'Fahrenheit to Celsius':
        output = (input - 32) * 5 / 9;
        break;
      case 'Kilograms to Pounds':
        output = input * 2.20462;
        break;
      case 'Pounds to Kilograms':
        output = input / 2.20462;
        break;
      default:
        output = 0;
    }

    setState(() {
      _result = 'Result: ${output.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Unit Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter value'),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedConversion,
              items: _conversionOptions
                  .map((String option) => DropdownMenuItem<String>(
                      value: option, child: Text(option)))
                  .toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedConversion = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _convert, child: Text('Convert')),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
