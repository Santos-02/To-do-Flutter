import 'package:flutter/material.dart';

class Tag {
  final String name;

  Tag({required this.name});
}

class Tags extends StatefulWidget {
  const Tags({super.key});

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  final List<Tag> tags = [
    Tag(name: 'Trabalho'),
    Tag(name: 'Faculdade'),
    Tag(name: 'Casa'),
  ];

  final TextEditingController _controller = TextEditingController();

  void _addTag() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        tags.add(Tag(name: name));
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Tags')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'Nome da Tag'),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addTag,
                  child: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  final tag = tags[index];
                  return ListTile(title: Text(tag.name));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
