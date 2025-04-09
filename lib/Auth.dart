import 'package:flutter/material.dart';

void main() => runApp(ToDoApp());

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ToDoHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Task {
  final String id;
  String title;
  bool isDone;

  Task({required this.id, required this.title, this.isDone = false});
}

class ToDoHomePage extends StatefulWidget {
  @override
  _ToDoHomePageState createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<ToDoHomePage> {
  final List<Task> _tasks = [];
  final _controller = TextEditingController();
  String? _editingId;

  void _addOrUpdateTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      if (_editingId == null) {
        _tasks.add(Task(id: DateTime.now().toString(), title: text));
      } else {
        final index = _tasks.indexWhere((task) => task.id == _editingId);
        if (index != -1) _tasks[index].title = text;
        _editingId = null;
      }
      _controller.clear();
    });
  }

  void _editTask(Task task) {
    setState(() {
      _controller.text = task.title;
      _editingId = task.id;
    });
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
  }

  void _toggleDone(Task task) {
    setState(() {
      task.isDone = !task.isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: _editingId == null ? 'Enter a new task' : 'Edit task',
                suffixIcon: IconButton(
                  icon: Icon(Icons.save),
                  onPressed: _addOrUpdateTask,
                ),
              ),
              onSubmitted: (_) => _addOrUpdateTask(),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _tasks.isEmpty
                  ? Center(child: Text('No tasks yet!'))
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (ctx, index) {
                        final task = _tasks[index];
                        return ListTile(
                          leading: Checkbox(
                            value: task.isDone,
                            onChanged: (_) => _toggleDone(task),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isDone ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editTask(task),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTask(task.id),
                              ),
                            ],
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
