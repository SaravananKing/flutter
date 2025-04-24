import 'package:flutter/material.dart';

void main() => runApp(TimeZoneConverterApp());

class TimeZoneConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TimeZoneConverterScreen(),
    );
  }
}

class TimeZoneConverterScreen extends StatefulWidget {
  @override
  _TimeZoneConverterScreenState createState() =>
      _TimeZoneConverterScreenState();
}

class _TimeZoneConverterScreenState extends State<TimeZoneConverterScreen> {
  final TextEditingController timeController = TextEditingController();
  String fromZone = 'UTC';
  String toZone = 'UTC+5:30';

  final Map<String, double> timeZoneOffsets = {
    'UTC-8': -8,
    'UTC-5': -5,
    'UTC': 0,
    'UTC+1': 1,
    'UTC+5:30': 5.5,
    'UTC+8': 8,
  };

  String convertedTime = '';

  void convert() {
    String input = timeController.text.trim();
    if (!RegExp(r'^\d{1,2}:\d{2}$').hasMatch(input)) {
      setState(() {
        convertedTime = 'Invalid format! Use HH:MM';
      });
      return;
    }

    List<String> parts = input.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      setState(() {
        convertedTime = 'Invalid time range!';
      });
      return;
    }

    double diff = timeZoneOffsets[toZone]! - timeZoneOffsets[fromZone]!;
    int hourDiff = diff.floor();
    int minuteDiff = ((diff - hourDiff) * 60).round();

    int newHour = hour + hourDiff;
    int newMinute = minute + minuteDiff;

    if (newMinute >= 60) {
      newMinute -= 60;
      newHour += 1;
    } else if (newMinute < 0) {
      newMinute += 60;
      newHour -= 1;
    }

    if (newHour >= 24) newHour -= 24;
    if (newHour < 0) newHour += 24;

    setState(() {
      convertedTime =
      '${newHour.toString().padLeft(2, '0')}:${newMinute.toString().padLeft(2, '0')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Time Converter')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: timeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Time (HH:MM)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('From: '),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: fromZone,
                  items: timeZoneOffsets.keys.map((zone) {
                    return DropdownMenuItem(value: zone, child: Text(zone));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      fromZone = value!;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text('To:     '),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: toZone,
                  items: timeZoneOffsets.keys.map((zone) {
                    return DropdownMenuItem(value: zone, child: Text(zone));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      toZone = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: convert,
              child: Text('Convert Time'),
            ),
            SizedBox(height: 20),
            Text(
              'Converted Time: $convertedTime',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
