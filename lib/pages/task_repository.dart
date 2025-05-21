import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'task_model.dart';

class TaskRepository {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/tasks.json');
  }

  Future<List<TaskModel>> loadTasks() async {
    try {
      final file = await _localFile;

      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = json.decode(contents);
        return jsonData.map((e) => TaskModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final file = await _localFile;
    final jsonData = tasks.map((e) => e.toJson()).toList();
    await file.writeAsString(json.encode(jsonData));
  }
}
