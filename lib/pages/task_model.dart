import 'dart:convert';

class TaskModel {
  String description;
  DateTime? dateTime;
  String? tag;
  bool isCompleted;

  TaskModel({
    required this.description,
    this.dateTime,
    this.tag,
    this.isCompleted = false,
  });

  TaskModel copyWith({
    String? description,
    DateTime? dateTime,
    String? tag,
    bool? isCompleted,
  }) {
    return TaskModel(
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      tag: tag ?? this.tag,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'dateTime': dateTime?.toIso8601String(),
      'tag': tag,
      'isCompleted': isCompleted,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      description: json['description'],
      dateTime:
          json['dateTime'] != null ? DateTime.parse(json['dateTime']) : null,
      tag: json['tag'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  static String encode(List<TaskModel> tasks) =>
      json.encode(tasks.map<Map<String, dynamic>>((t) => t.toJson()).toList());

  static List<TaskModel> decode(String tasks) =>
      (json.decode(tasks) as List<dynamic>)
          .map<TaskModel>((item) => TaskModel.fromJson(item))
          .toList();
}
