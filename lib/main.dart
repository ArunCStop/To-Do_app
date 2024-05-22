import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: ToDoApp()));
}

class ToDoApp extends StatefulWidget {
  @override
  _ToDoAppState createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  final _tasks = <String>[];
  final _taskCheck = <bool>[];
  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('To Do'),
          backgroundColor: Colors.grey,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 221, 218, 218),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(_tasks[index]),
                    value: _taskCheck[index],
                    onChanged: (bool? value) {
                      setState(() {
                        _taskCheck[index] = value!;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Add a task'),
                  content: TextField(
                    controller: _textFieldController,
                    decoration: const InputDecoration(hintText: "Task name"),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Add'),
                      onPressed: () {
                        setState(() {
                          _tasks.add(_textFieldController.text);
                          _taskCheck.add(false);
                        });
                        _textFieldController.clear();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
