import 'package:flutter/material.dart';
import 'package:to_do_list/pages/tags.dart';
import 'pages/home_page.dart';
import 'pages/task.dart';
//import 'pages/tags_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(title: 'Lista de Tarefas'),
        '/form': (context) => const Task(),
        '/tags': (context) => const Tags(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
