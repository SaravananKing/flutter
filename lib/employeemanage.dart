import 'package:flutter/material.dart';

void main() {
  runApp(EmployeeApp());
}

class EmployeeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EmployeeScreen(),
    );
  }
}

class EmployeeScreen extends StatefulWidget {
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final List<Map<String, String>> employees = [];
  final nameController = TextEditingController();
  final positionController = TextEditingController();
  final salaryController = TextEditingController();

  void _addEmployee() {
    if (nameController.text.isEmpty ||
        positionController.text.isEmpty ||
        salaryController.text.isEmpty) return;

    setState(() {
      employees.add({
        'name': nameController.text,
        'position': positionController.text,
        'salary': salaryController.text,
      });
      _clearInputs();
    });
  }

  void _editEmployee(int index) {
    nameController.text = employees[index]['name']!;
    positionController.text = employees[index]['position']!;
    salaryController.text = employees[index]['salary']!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Employee'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: positionController, decoration: InputDecoration(labelText: 'Position')),
            TextField(controller: salaryController, decoration: InputDecoration(labelText: 'Salary')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                employees[index] = {
                  'name': nameController.text,
                  'position': positionController.text,
                  'salary': salaryController.text,
                };
              });
              _clearInputs();
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteEmployee(int index) {
    setState(() {
      employees.removeAt(index);
    });
  }

  void _clearInputs() {
    nameController.clear();
    positionController.clear();
    salaryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee Manager')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: positionController, decoration: InputDecoration(labelText: 'Position')),
            TextField(
              controller: salaryController,
              decoration: InputDecoration(labelText: 'Salary'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _addEmployee, child: Text('Add Employee')),
            Expanded(
              child: ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final emp = employees[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(emp['name']!),
                      subtitle: Text('Position: ${emp['position']}\nSalary: ${emp['salary']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: Icon(Icons.edit), onPressed: () => _editEmployee(index)),
                          IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteEmployee(index)),
                        ],
                      ),
                    ),
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
