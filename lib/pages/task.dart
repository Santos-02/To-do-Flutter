import 'package:flutter/material.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final TextEditingController controller = TextEditingController();
  bool isEditing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    if (args != null && args.containsKey('task')) {
      controller.text = args['task'];
      isEditing = true;
    }
  }

  void submit() {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      Navigator.pop(context, text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Tarefa' : 'Nova Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: isEditing ? 'Editar tarefa' : 'Digite a nova tarefa',
              ),

              onSubmitted: (_) => submit(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: submit,
              child: Text(isEditing ? 'Salvar Alterações' : 'Adicionar'),
            )
          ],
        ),
      ),
    );
  }
}
