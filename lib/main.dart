import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/task.dart';

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
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
