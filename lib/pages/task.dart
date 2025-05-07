import 'package:flutter/material.dart';
import 'task_model.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final TextEditingController controller = TextEditingController();
  DateTime? selectedDateTime;
  String? selectedTag;

  final List<String> availableTags = ['Trabalho', 'Faculdade', 'Saúde'];

  bool isEditing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    if (args != null && args.containsKey('task')) {
      final task = args['task'] as TaskModel;
      controller.text = task.description;
      selectedDateTime = task.dateTime;
      selectedTag = task.tag;
      isEditing = true;
    }
  }

  void pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime:
          selectedDateTime != null
              ? TimeOfDay.fromDateTime(selectedDateTime!)
              : TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void submit() {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      Navigator.pop(
        context,
        TaskModel(
          description: text,
          dateTime: selectedDateTime,
          tag: selectedTag,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Tarefa' : 'Nova Tarefa')),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDateTime != null
                      ? '${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year} ${selectedDateTime!.hour}:${selectedDateTime!.minute.toString().padLeft(2, '0')}'
                      : 'Nenhuma data selecionada',
                ),
                TextButton(
                  onPressed: pickDateTime,
                  child: const Text('Selecionar Data/Hora'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedTag,
              hint: const Text('Selecione uma tag'),
              items:
                  availableTags.map((tag) {
                    return DropdownMenuItem<String>(
                      value: tag,
                      child: Text(tag),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTag = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: submit,
              child: Text(isEditing ? 'Salvar Alterações' : 'Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
