import 'package:flutter/material.dart';

void main() {
  runApp(FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker',
      theme: ThemeData(primarySwatch: Colors.green),
      home: FitnessTrackerScreen(),
    );
  }
}

class FitnessTrackerScreen extends StatefulWidget {
  @override
  _FitnessTrackerScreenState createState() => _FitnessTrackerScreenState();
}

class _FitnessTrackerScreenState extends State<FitnessTrackerScreen> {
  int steps = 0;
  double calories = 0.0;
  final List<double> progress = [];

  final TextEditingController stepsController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();

  void _updateData() {
    setState(() {
      steps = int.tryParse(stepsController.text) ?? 0;
      calories = double.tryParse(caloriesController.text) ?? 0.0;
      progress.add((steps / 10000).clamp(0.0, 1.0));
    });

    stepsController.clear();
    caloriesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fitness Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: stepsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Steps'),
            ),
            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Calories Burned'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateData,
              child: Text('Update'),
            ),
            SizedBox(height: 20),
            Text("Today's Steps: $steps", style: TextStyle(fontSize: 18)),
            Text("Calories Burned: ${calories.toStringAsFixed(1)} kcal", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("Workout Progress", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.separated(
                itemCount: progress.length,
                separatorBuilder: (_, __) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return LinearProgressIndicator(
                    value: progress[index],
                    minHeight: 10,
                    color: Colors.green,
                    backgroundColor: Colors.grey[300],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
