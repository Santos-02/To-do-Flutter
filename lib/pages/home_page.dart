import 'package:flutter/material.dart';
import 'task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TaskModel> tasks = [];

  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void markTaskCompleted(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      tasks.sort((a, b) {
        if (a.isCompleted && !b.isCompleted) return 1;
        if (!a.isCompleted && b.isCompleted) return -1;
        return 0;
      });
    });
  }

  void addTask(TaskModel task) {
    setState(() {
      task.isCompleted = false;
      tasks.add(task);
    });
  }

  void updateTask(int index, TaskModel updatedTask) {
    setState(() {
      updatedTask.isCompleted = tasks[index].isCompleted;
      tasks[index] = updatedTask;
    });
  }

  void _handleTaskFormResult(dynamic result, {int? editIndex}) {
    if (result != null && result is Map<String, dynamic>) {
      final String text = result['text'] as String;
      final DateTime? date = result['date'] as DateTime?;
      final TimeOfDay? time = result['time'] as TimeOfDay?;
      final String? originalText = result['originalText'] as String?;

      DateTime? combinedDateTime;
      if (date != null) {
        if (time != null) {
          combinedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        } else {
          combinedDateTime = date;
        }
      }

      if (editIndex != null) {
        if (text.isEmpty && originalText != null) {
          setState(() {
            tasks.removeAt(editIndex);
          });
        } else if (text.isNotEmpty) {
          setState(() {
            bool currentCompletionStatus = tasks[editIndex].isCompleted;
            tasks[editIndex] = TaskModel(
              description: text,
              dateTime: combinedDateTime,
              isCompleted: currentCompletionStatus, // Mantém o status
            );
          });
        }
      } else if (text.isNotEmpty) {
        // Adicionando nova tarefa
        setState(() {
          tasks.add(
            TaskModel(
              description: text,
              dateTime: combinedDateTime,
              isCompleted: false, // Novas tarefas não estão completas
            ),
          );
        });
      }
    } else if (result != null && result is TaskModel) {
      // Se o seu formulário já retorna um TaskModel completo
      if (editIndex != null) {
        setState(() {
          // Se o result.isCompleted não for gerenciado pela tela de form,
          // preserve o estado atual.
          bool currentCompletionStatus = tasks[editIndex].isCompleted;
          result.isCompleted = currentCompletionStatus;
          tasks[editIndex] = result;
        });
      } else {
        setState(() {
          result.isCompleted = false; // Novas tarefas
          tasks.add(result);
        });
      }
    }
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
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.label),
            tooltip: 'Gerenciar Tags',
            onPressed: () {
              Navigator.pushNamed(context, '/tags');
            },
          ),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body:
          tasks.isEmpty
              ? const Center(
                child: Text(
                  'Nenhuma tarefa criada',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: task.isCompleted,
                          onChanged: (bool? value) {
                            if (value != null) toggleTaskCompletion(index);
                          },
                          activeColor: Colors.deepPurple,
                        ),
                        if (task.tag != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              task.tag!,
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ),
                      ],
                    ),

                    title: Text(
                      task.description,
                      style: TextStyle(
                        decoration:
                            task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                        color: task.isCompleted ? Colors.grey[600] : null,
                      ),
                    ),
                    subtitle:
                        task.dateTime != null
                            ? Text(
                              '${task.dateTime!.day}/${task.dateTime!.month}/${task.dateTime!.year} ${task.dateTime!.hour}:${task.dateTime!.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                decoration:
                                    task.isCompleted
                                        ? TextDecoration
                                            .lineThrough // Mesmo efeito de riscar
                                        : TextDecoration.none,
                                color:
                                    task.isCompleted
                                        ? Colors.grey[500] // Cor mais clara
                                        : null,
                              ),
                            )
                            : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed:
                              task.isCompleted
                                  ? null
                                  : () async {
                                    final result = await Navigator.pushNamed(
                                      context,
                                      '/form', // Sua rota para a tela de adicionar/editar tarefa
                                      arguments: {
                                        // Passando os dados da tarefa para a tela de formulário
                                        'task': task,
                                        'date': task.dateTime,
                                        // Se sua tela de form puder lidar com TimeOfDay separadamente
                                        'time':
                                            task.dateTime != null
                                                ? TimeOfDay.fromDateTime(
                                                  task.dateTime!,
                                                )
                                                : null,
                                      },
                                    );
                                    _handleTaskFormResult(
                                      result,
                                      editIndex: index,
                                    );
                                  },
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteTask(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(context, '/form');
            if (result != null) {
              addTask(result as TaskModel);
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Nova Tarefa'),
        ),
      ),
    );
  }
}
