import 'package:flutter/material.dart';

void main() {
  runApp(CalorieBurnApp());
}

class CalorieBurnApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calorie Burn Calculator',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: CalorieBurnScreen(),
    );
  }
}

class CalorieBurnScreen extends StatefulWidget {
  @override
  _CalorieBurnScreenState createState() => _CalorieBurnScreenState();
}

class _CalorieBurnScreenState extends State<CalorieBurnScreen> {
  TextEditingController weightController = TextEditingController(text: "60");
  TextEditingController durationController = TextEditingController(text: "30");
  String selectedActivity = 'Running';
  double caloriesBurned = 0.0;

  final Map<String, double> activityMETs = {
    'Running': 8.0,
    'Walking': 3.5,
    'Cycling': 6.0,
    'Swimming': 7.0,
  };

  void calculateCalories() {
    double? weight = double.tryParse(weightController.text);
    double? duration = double.tryParse(durationController.text);

    if (weight != null && duration != null) {
      double met = activityMETs[selectedActivity] ?? 3.5;
      setState(() {
        caloriesBurned = (met * 3.5 * weight / 200) * duration;
      });
    } else {
      setState(() {
        caloriesBurned = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter valid numbers")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calorie Burn Calculator')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Weight (kg):", style: TextStyle(fontSize: 16)),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Enter weight in kg"),
            ),
            SizedBox(height: 10),
            Text("Activity:", style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: selectedActivity,
              items: activityMETs.keys.map((activity) {
                return DropdownMenuItem(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedActivity = val!),
            ),
            SizedBox(height: 10),
            Text("Duration (minutes):", style: TextStyle(fontSize: 16)),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Enter duration in minutes"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateCalories,
              child: Text("Calculate"),
            ),
            SizedBox(height: 20),
            Text(
              "Calories Burned: ${caloriesBurned.toStringAsFixed(2)} kcal",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
