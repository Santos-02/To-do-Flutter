import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> tasks = [];

  void addTask(String task) {
    setState(() {
      tasks.add(task);
    });
  }

  void updateTask(int index, String updatedTask) {
    setState(() {
      tasks[index] = updatedTask;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder:
                  (context, index) => ListTile(
                    title: Text(tasks[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              '/form',
                              arguments: {'task': tasks[index], 'index': index},
                            );
                            if (result != null) {
                              updateTask(index, result as String);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteTask(index),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/form');
              if (result != null) {
                addTask(result as String);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(10.0),
            ),
            child: Text('Nova Tarefa')
          ),
        ],
      ),
    );
  }
}
