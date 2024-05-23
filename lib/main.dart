import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(home: ToDoApp()));
}

class ToDoApp extends StatefulWidget {
  @override
  _ToDoAppState createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  var _tasks = <Map<String, String>>[];
  final _taskCheck = <bool>[];
  final _textFieldController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks', _tasks.cast<String>());
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = prefs.getStringList('tasks');
    if (tasks != null) {
      setState(() {
        _tasks = tasks.cast<Map<String, String>>();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        hintColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        hintColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('To-Do App'),
          backgroundColor: Colors.grey,
          actions: <Widget>[
            IconButton(
              icon: Icon(_isDarkMode ? Icons.brightness_7 : Icons.brightness_3),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _isDarkMode ? Colors.black : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.5)
                            : Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(_tasks[index]['name']!),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(_tasks[index]['name'] ?? ""),
                            content: Text(_tasks[index]['description'] ?? ""),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    leading: Checkbox(
                      value: _taskCheck[index],
                      onChanged: (bool? value) {
                        setState(() {
                          _taskCheck[index] = value!;
                        });
                      },
                    ),
                    trailing: DropdownButton<String>(
                      icon: const Icon(Icons.more_vert),
                      items: <String>['Edit', 'Delete'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        if (value == 'Delete') {
                          setState(() {
                            _tasks.removeAt(index);
                            _taskCheck.removeAt(index);
                          });
                          _saveTasks();
                        } else if (value == 'Edit') {
                          _textFieldController.text =
                              _tasks[index]['name'] ?? '';
                          _descriptionController.text =
                              _tasks[index]['description'] ?? '';

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Edit task'),
                                content: Column(
                                  children: <Widget>[
                                    TextField(
                                      controller: _textFieldController,
                                      decoration: const InputDecoration(
                                          hintText: "Task name"),
                                    ),
                                    TextField(
                                      controller: _descriptionController,
                                      decoration: const InputDecoration(
                                          hintText: "Task description"),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: const Text('Update'),
                                    onPressed: () {
                                      setState(() {
                                        _tasks[index] = {
                                          'name': _textFieldController.text,
                                          'description':
                                              _descriptionController.text,
                                        };
                                      });
                                      _textFieldController.clear();
                                      _descriptionController.clear();
                                      Navigator.of(context).pop();
                                      _saveTasks();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
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
                  title: const Text('Add task'),
                  content: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
                          maxWidth: MediaQuery.of(context).size.width),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: _textFieldController,
                            decoration:
                                const InputDecoration(hintText: "Task name"),
                          ),
                          TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                                hintText: "Task description"),
                          ),
                        ],
                      ),
                    ),
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
                            _tasks.add({
                              'name': _textFieldController.text,
                              'description': _descriptionController.text,
                            });
                            _taskCheck.add(false);
                            _saveTasks();
                          });
                          _textFieldController.clear();
                          _descriptionController.clear();
                          Navigator.of(context).pop();
                        }),
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
