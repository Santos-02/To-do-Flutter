import 'package:flutter/material.dart';

class Tag {
  final String name;
  final IconData icon;

  Tag({required this.name, required this.icon});
}

class Tags extends StatefulWidget {
  const Tags({super.key});

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  final List<Tag> tags = [
    Tag(name: 'Trabalho', icon: Icons.work),
    Tag(name: 'Faculdade', icon: Icons.school),
    Tag(name: 'Saúde', icon: Icons.favorite),
  ];

  final TextEditingController _controller = TextEditingController();
  IconData? _selectedIcon;

  void _addTag() {
    final name = _controller.text.trim();
    if (name.isNotEmpty && _selectedIcon != null) {
      setState(() {
        tags.add(Tag(name: name, icon: _selectedIcon!));
        _controller.clear();
        _selectedIcon = null;
      });
    }
  }

  void _openIconPicker() async {
    final icon = await showDialog<IconData>(
      context: context,
      builder: (context) => const IconPickerDialog(),
    );
    if (icon != null) {
      setState(() {
        _selectedIcon = icon;
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
                IconButton(
                  icon: Icon(_selectedIcon ?? Icons.add_circle_outline),
                  onPressed: _openIconPicker,
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
                  return ListTile(
                    leading: Icon(tag.icon),
                    title: Text(tag.name),
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

class IconPickerDialog extends StatelessWidget {
  const IconPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.work,
      Icons.school,
      Icons.favorite,
      Icons.home,
      Icons.fitness_center,
      Icons.music_note,
      Icons.shopping_cart,
      Icons.book,
      Icons.flight,
      Icons.code,
      Icons.pets,
      Icons.local_cafe,
      Icons.nightlife,
      Icons.palette,
      Icons.sports_soccer,
    ];

    return AlertDialog(
      title: const Text('Escolha um ícone'),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: icons.length,
          itemBuilder: (context, index) {
            return IconButton(
              icon: Icon(icons[index]),
              onPressed: () => Navigator.pop(context, icons[index]),
            );
          },
        ),
      ),
    );
  }
}
